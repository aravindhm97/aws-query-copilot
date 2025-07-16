# File: backend/api.py
import os
import logging
import boto3
import json
import requests
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
from datetime import datetime, timedelta

# Load environment variables
load_dotenv()

# === ENV CONFIG ===
HF_TOKEN = os.getenv("HF_TOKEN")
HF_MODEL = os.getenv("HF_MODEL") or "defog/sqlcoder-7b"
ATHENA_DB = os.getenv("ATHENA_DB")
ATHENA_OUTPUT = os.getenv("ATHENA_OUTPUT_LOCATION")
REGION = os.getenv("AWS_REGION", "ap-south-1")

# === FASTAPI APP ===
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# === LOGGING ===
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("api")

# === AWS CLIENT ===
athena = boto3.client("athena", region_name=REGION)

# === FALLBACK RULES ===
def fallback_sql(question: str) -> str:
    q = question.lower()
    now = datetime.now()
    seven_days_ago = now - timedelta(days=7)
    date_filter = f"AND timestamp >= DATE('{seven_days_ago.date()}')"

    if "login" in q:
        return f"SELECT * FROM events WHERE event_type = 'login' LIMIT 50"
    elif "signup" in q:
        return f"SELECT * FROM events WHERE event_type = 'signup' LIMIT 50"
    elif "purchase" in q:
        if "7 days" in q or "week" in q:
            return f"SELECT * FROM events WHERE event_type = 'purchase' {date_filter} LIMIT 50"
        return f"SELECT * FROM events WHERE event_type = 'purchase' LIMIT 50"
    elif "last 7 days" in q:
        return f"SELECT * FROM events WHERE timestamp >= DATE('{seven_days_ago.date()}') LIMIT 50"
    elif "all users" in q:
        return "SELECT DISTINCT user_id FROM events LIMIT 50"
    return ""

# === ROUTE ===
@app.post("/ask")
async def ask(request: Request):
    body = await request.json()
    question = body.get("question")
    logger.info(f"💬 Question received: {question}")

    # === HuggingFace Inference ===
    headers = {"Authorization": f"Bearer {HF_TOKEN}"}
    payload = {"inputs": question}
    try:
        logger.info("📦 Using model via HuggingFace Inference API...")
        res = requests.post(
            f"https://api-inference.huggingface.co/models/{HF_MODEL}",
            headers=headers, json=payload, timeout=60
        )
        res.raise_for_status()
        generated_text = res.json()[0]["generated_text"]
        logger.info(f"📝 Raw model output: {generated_text}")
    except Exception as e:
        logger.warning(f"⚠️ Model call failed: {e}")
        generated_text = ""

    if not generated_text or not generated_text.lower().startswith("select"):
        logger.warning("⚠️ Model fallback triggered: 🚫 Invalid SQL generated")
        generated_text = fallback_sql(question)

    logger.info(f"🧠 Final SQL to Athena: {generated_text}")
    if not generated_text:
        return {"error": "Unable to generate SQL."}

    try:
        response = athena.start_query_execution(
            QueryString=generated_text,
            QueryExecutionContext={"Database": ATHENA_DB},
            ResultConfiguration={"OutputLocation": ATHENA_OUTPUT}
        )
        execution_id = response["QueryExecutionId"]
        status = "RUNNING"
        while status in ["QUEUED", "RUNNING"]:
            result = athena.get_query_execution(QueryExecutionId=execution_id)
            status = result["QueryExecution"]["Status"]["State"]

        if status != "SUCCEEDED":
            raise Exception("Athena query failed: " + status)

        results = athena.get_query_results(QueryExecutionId=execution_id)
        columns = [col["VarCharValue"] for col in results["ResultSet"]["Rows"][0]["Data"]]
        records = [
            dict(zip(columns, [col.get("VarCharValue", "") for col in row["Data"]]))
            for row in results["ResultSet"]["Rows"][1:]
        ]
        return {"query": generated_text, "results": records}

    except Exception as e:
        logger.error(f"❌ Error: {e}")
        return {"error": str(e)}
