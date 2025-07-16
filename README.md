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

> ## 📝 Prerequisites
> Please check the [PREREQUISITES.md](./PREREQUISITES.md) file for a step-by-step installation guide on setting up all required tools.

---

> ## 📝 Prerequisites
> Please follow the [DEPLOYMENT.md](./DEPLOYMENT.md) file for the step-by-step detailed guide for installation.

---

### 📝 Example Prompts
- "Top 10 customers by purchase volume last quarter"
- "Orders from Bangalore in the last 7 days"
- "Revenue by region for 2023"

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
