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

- Frontend: http://localhost:8501
- Backend (FastAPI docs): http://localhost:8000/docs

## ☁️ AWS Infrastructure Deployment (Terraform)
```bash
cd terraform
terraform init
terraform apply
```

- Athena workgroup: query-copilot-wg
- Query results: S3 bucket query-copilot-demo-bucket

### 📝 Example Prompts
- "Top 10 customers by purchase volume last quarter"
- "Orders from Bangalore in the last 7 days"
- "Revenue by region for 2023"

### 🔐 Env Variables
Create a .env file inside backend/ with:
```bash
HUGGINGFACE_API_TOKEN=your_token_here
(Free token from https://huggingface.co/settings/tokens)
```

### 📁 Project Structure
```bash
query-copilot/
├── backend/
│   ├── api.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .env
├── frontend/
│   ├── streamlit_app.py
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .env
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   └── outputs.tf
└── docker-compose.yml
```

### 💡 Credits
Built with ❤️ by Aravindh — [LinedIn](https://www.linkedin.com/in/aravindhkumar-m1997/) | [GitHub](https://github.com/aravindhm97)

The background color is `#ffffff` for light mode and `#000000` for dark mode.
