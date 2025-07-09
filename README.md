# DevOps Application

A comprehensive DevOps application with Flask backend, containerized deployment, monitoring, and CI/CD pipeline.

## 🏗️ Architecture

- **Application**: Flask-based REST API
- **Infrastructure**: AWS ECS with Terraform
- **Monitoring**: Prometheus + Grafana
- **CI/CD**: GitHub Actions
- **Containerization**: Docker & Docker Compose

## 🚀 Quick Start

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Devops-App
   ```

2. **Run with Docker Compose**
   ```bash
   docker-compose up --build
   ```

3. **Access the application**
   - Application: http://localhost:5000
   - Prometheus: http://localhost:9090
   - Grafana: http://localhost:3000 (admin/admin)

### API Endpoints

- `GET /` - Home endpoint
- `GET /health` - Health check
- `GET /metrics` - Metrics for Prometheus
- `GET /api/status` - API status

## 🧪 Testing

```bash
# Install dependencies
pip install -r app/requirements.txt

# Run tests
pytest app/tests/

# Code formatting
black app/

# Linting
flake8 app/
```

## 🏗️ Infrastructure Deployment

### Prerequisites

- AWS CLI configured
- Terraform installed
- Docker Hub account

### Deploy to Environment

1. **Initialize Terraform**
   ```bash
   cd infra
   terraform init -backend-config=envs/prod/backend.tf
   ```

2. **Plan deployment**
   ```bash
   terraform plan -var-file=envs/prod/prod.tfvars
   ```

3. **Apply deployment**
   ```bash
   terraform apply -var-file=envs/prod/prod.tfvars
   ```

## 📊 Monitoring

- **Prometheus**: Metrics collection at `:9090`
- **Grafana**: Visualization at `:3000`
- **Redis**: Caching at `:6379`

## 🔧 CI/CD Pipeline

The GitHub Actions workflow includes:

1. **Testing**: Unit tests, linting, security scanning
2. **Building**: Docker image build and push
3. **Deployment**: Automated deployment to staging/production
4. **Monitoring**: Health checks and notifications

### Required Secrets

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`

## 📁 Project Structure

```
├── app/                    # Flask application
│   ├── app.py             # Main application
│   ├── requirements.txt   # Python dependencies
│   └── tests/            # Test files
├── infra/                 # Terraform infrastructure
│   ├── main.tf           # Main infrastructure
│   ├── provider.tf       # AWS provider
│   ├── envs/             # Environment-specific configs
│   └── modules/          # Reusable modules
├── monitoring/           # Monitoring configuration
├── .github/workflows/    # CI/CD pipeline
├── docker-compose.yml    # Local development
└── Dockerfile           # Container definition
```

## 🔒 Security

- Non-root container user
- Security scanning with Trivy
- Dependency vulnerability checks
- Secrets management with AWS SSM

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Run tests and linting
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
