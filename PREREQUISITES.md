# Prerequisites for Query Copilot 🧠

Before you can run **Query Copilot** locally or deploy it to AWS, make sure you have the following tools installed and configured.

---

## 1. **Docker** 🐳

**Docker** is used to containerize the application, so it can run consistently across all environments.

### How to Install:

- [Download Docker Desktop](https://www.docker.com/products/docker-desktop) (for Windows/Mac)
- Follow installation instructions for your OS.

After installation, verify by running:
```bash
docker --version
docker-compose --version
```

## 2. **Git** 🦸‍♂️

**Git** is used for version control and managing the source code.

### How to Install:
- [Download Git](https://git-scm.com/downloads) (for Windows/Mac/Linux)
- Follow installation instructions for your OS.

Verify by running:
```bash
git --version
```

## 3. **Hugging Face Token** 💡
**Hugging Face** is used for the AI model (`defog/sqlcoder-7b-2`) that translates plain English into SQL.

### How to Install:
1. Go to [Hugging Face Account Settings](https://huggingface.co/settings/tokens).
2. Create a new token under Access Tokens.
3. Copy the token and save it.

### Setup in the Project:
Create a `.env` file in the `backend/` folder with the following:

```env
HUGGINGFACE_API_TOKEN=your_token_here
```

## 4. **Terraform** ☁️
**Terraform** is used to manage AWS resources, like S3 and Athena, via infrastructure-as-code.

### How to Install:
- [Download Terraform](https://developer.hashicorp.com/terraform/install) (for Windows/Mac/Linux)
- Follow installation instructions for your OS.

Verify by running:
```bash
terraform --version
```

## 5. **AWS CLI** 🌐
**AWS CLI** is used for interacting with your AWS account from the command line. You will use it to authenticate and deploy infrastructure via Terraform.

### How to Install:
- [Download AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (for Windows/Mac/Linux)
- Follow installation instructions for your OS.

### Configure AWS CLI:
Run the following command to configure your AWS credentials:

```bash
aws configure
```
Enter the following:

- AWS Access Key ID: (Get it from AWS IAM Console)
- AWS Secret Access Key: (Get it from AWS IAM Console)
- Default region name: ap-south-1 (or your preferred region)
- Default output format: json

Verify by running:
```bash
aws sts get-caller-identity
```

## 6. **Python** 🐍 (for local development)
**Python** is required for running the backend and frontend. This project uses Python 3.10+.

### How to Install:
- [Download Python](https://www.python.org/downloads/) (for Windows/Mac/Linux)
- Follow installation instructions for your OS.

After installation, verify by running:
```bash
python --version
pip --version
```

## 7. **Streamlit* 🎨 (Frontend UI)
**Streamlit** is used for the frontend interface, which allows users to interact with the application via a web UI.

Install Streamlit using `pip` (Python package manager):
```bash
pip install streamlit
```
Verify by running:
```bash
streamlit --version
```
