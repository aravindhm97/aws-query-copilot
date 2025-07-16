## 🧪 Local Deployment (Docker Compose)

1. Clone the repository:
```bash
git clone https://github.com/<your-username>/query-copilot.git
cd query-copilot
```
2. Add your Hugging Face API Token to `backend/.env`.
3. Build and run with Docker:
```bash
docker-compose up --build
```
4. Visit the application at:
- **Frontend**: http://localhost:8501
- **Backend** (FastAPI docs): http://localhost:8000/docs

---

## ☁️ AWS Infrastructure Deployment (Terraform)

1. Navigate to the Terraform folder:
```bash
cd terraform
```
2. Initialize Terraform:
```bash
terraform init
```
3. Apply the infrastructure: 
```bash
terraform apply -auto-approve
```
