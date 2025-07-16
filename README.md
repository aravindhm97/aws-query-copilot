# 🧠 Query Copilot — Natural Language to Athena SQL

**Query Copilot** turns plain English into executable AWS Athena SQL queries using a Hugging Face model, FastAPI backend, and Streamlit frontend. Built for cloud-scale data exploration.

---

## 🚀 Features

- 🧠 Natural Language → SQL Translation (`defog/sqlcoder-7b-2`)
- ⚙️ FastAPI backend for model inference
- 🎨 Streamlit frontend UI
- 🐳 Docker & Docker Compose ready
- ☁️ AWS Terraform Infrastructure: S3, Athena, IAM

---

## 🧪 Local Deployment (Docker Compose)

```bash
git clone https://github.com/your-username/query-copilot.git
cd query-copilot
docker-compose up --build
```

-Frontend: http://localhost:8501
-Backend (FastAPI docs): http://localhost:8000/docs

## ☁️ AWS Infrastructure Deployment (Terraform)
```bash
cd terraform
terraform init
terraform apply
```
-Athena workgroup: query-copilot-wg
-Query results: S3 bucket query-copilot-demo-bucket
