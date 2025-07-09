# Infrastructure Architecture

This document provides a comprehensive overview of the DevOps application infrastructure architecture deployed on AWS using Terraform.

## 🏗️ High-Level Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                   AWS CLOUD                                     │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                            VPC (10.x.0.0/16)                            │   │
│  │                                                                         │   │
│  │  ┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────┐ │   │
│  │  │   Availability       │  │   Availability       │  │   Availability   │ │   │
│  │  │   Zone A            │  │   Zone B            │  │   Zone C        │ │   │
│  │  │                     │  │                     │  │                 │ │   │
│  │  │ ┌─────────────────┐ │  │ ┌─────────────────┐ │  │ ┌─────────────┐ │ │   │
│  │  │ │  Public Subnet  │ │  │ │  Public Subnet  │ │  │ │ Public Sub. │ │ │   │
│  │  │ │ 10.x.1.0/24     │ │  │ │ 10.x.2.0/24     │ │  │ │10.x.3.0/24  │ │ │   │
│  │  │ │                 │ │  │ │                 │ │  │ │             │ │ │   │
│  │  │ │ ┌─────────────┐ │ │  │ │ ┌─────────────┐ │  │ │ ┌─────────┐ │ │ │   │
│  │  │ │ │     NAT     │ │ │  │ │ │     NAT     │ │  │ │ │   NAT   │ │ │ │   │
│  │  │ │ │   Gateway   │ │ │  │ │ │   Gateway   │ │  │ │ │ Gateway │ │ │ │   │
│  │  │ │ └─────────────┘ │ │  │ │ └─────────────┘ │  │ │ └─────────┘ │ │ │   │
│  │  │ └─────────────────┘ │  │ └─────────────────┘ │  │ └─────────────┘ │ │   │
│  │  │                     │  │                     │  │                 │ │   │
│  │  │ ┌─────────────────┐ │  │ ┌─────────────────┐ │  │ ┌─────────────┐ │ │   │
│  │  │ │ Private Subnet  │ │  │ │ Private Subnet  │ │  │ │Private Sub. │ │ │   │
│  │  │ │ 10.x.101.0/24   │ │  │ │ 10.x.102.0/24   │ │  │ │10.x.103.0/24│ │ │   │
│  │  │ │                 │ │  │ │                 │ │  │ │             │ │ │   │
│  │  │ │ ┌─────────────┐ │ │  │ │ ┌─────────────┐ │  │ │ ┌─────────┐ │ │ │   │
│  │  │ │ │ ECS Tasks   │ │ │  │ │ │ ECS Tasks   │ │  │ │ │ECS Tasks│ │ │ │   │
│  │  │ │ │ (Fargate)   │ │ │  │ │ │ (Fargate)   │ │  │ │ │(Fargate)│ │ │ │   │
│  │  │ │ └─────────────┘ │ │  │ │ └─────────────┘ │  │ │ └─────────┘ │ │ │   │
│  │  │ └─────────────────┘ │  │ └─────────────────┘ │  │ └─────────────┘ │ │   │
│  │  └─────────────────────┘  └─────────────────────┘  └─────────────────┘ │   │
│  │                                                                         │   │
│  │  ┌─────────────────────────────────────────────────────────────────────┐ │   │
│  │  │                    Internet Gateway                                  │ │   │
│  │  └─────────────────────────────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                         AWS Services                                    │   │
│  │                                                                         │   │
│  │  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐              │   │
│  │  │      ECS      │  │      SSM      │  │   S3 Bucket   │              │   │
│  │  │   Cluster     │  │  Parameter    │  │  (Terraform   │              │   │
│  │  │               │  │    Store      │  │    State)     │              │   │
│  │  └───────────────┘  └───────────────┘  └───────────────┘              │   │
│  │                                                                         │   │
│  │  ┌───────────────┐  ┌───────────────┐                                 │   │
│  │  │   DynamoDB    │  │   CloudWatch  │                                 │   │
│  │  │  (Terraform   │  │    Logs       │                                 │   │
│  │  │    Lock)      │  │               │                                 │   │
│  │  └───────────────┘  └───────────────┘                                 │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## 🌐 Network Architecture

### VPC Configuration
- **CIDR Blocks**: Environment-specific (10.x.0.0/16)
  - **Production**: 10.0.0.0/16
  - **Staging**: 10.2.0.0/16
  - **QA**: 10.1.0.0/16
  - **Test**: 10.3.0.0/16

### Multi-AZ Deployment
```
┌─────────────────────────────────────────────────────────────┐
│                    us-east-1 Region                          │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ us-east-1a  │  │ us-east-1b  │  │ us-east-1c  │         │
│  │             │  │             │  │             │         │
│  │ Public:     │  │ Public:     │  │ Public:     │         │
│  │ 10.x.1.0/24 │  │ 10.x.2.0/24 │  │ 10.x.3.0/24 │         │
│  │             │  │             │  │             │         │
│  │ Private:    │  │ Private:    │  │ Private:    │         │
│  │10.x.101.0/24│  │10.x.102.0/24│  │10.x.103.0/24│         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

### Subnet Configuration
- **Public Subnets**: 3 subnets across 3 AZs (for NAT Gateways, Load Balancers)
- **Private Subnets**: 3 subnets across 3 AZs (for ECS Tasks, Application Layer)

## 🐳 Container Architecture

### ECS Fargate Deployment
```
┌─────────────────────────────────────────────────────────────────┐
│                    ECS Cluster                                  │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │ ECS Service │  │ ECS Service │  │ ECS Service │             │
│  │   (AZ-A)    │  │   (AZ-B)    │  │   (AZ-C)    │             │
│  │             │  │             │  │             │             │
│  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │             │
│  │ │ Task 1  │ │  │ │ Task 2  │ │  │ │ Task 3  │ │             │
│  │ │ Flask   │ │  │ │ Flask   │ │  │ │ Flask   │ │             │
│  │ │ App     │ │  │ │ App     │ │  │ │ App     │ │             │
│  │ │ Port:   │ │  │ │ Port:   │ │  │ │ Port:   │ │             │
│  │ │ 5000    │ │  │ │ 5000    │ │  │ │ 5000    │ │             │
│  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
```

## 🗄️ Data & State Management

### Terraform State Management
```
┌─────────────────────────────────────────────────────────────────┐
│                    State Management                             │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │                   S3 Buckets                             │ │
│  │                                                         │ │
│  │  ┌─────────────────┐  ┌─────────────────┐              │ │
│  │  │ devops-app-     │  │ devops-app-     │              │ │
│  │  │ terraform-      │  │ terraform-      │              │ │
│  │  │ state-prod      │  │ state-staging   │              │ │
│  │  └─────────────────┘  └─────────────────┘              │ │
│  │                                                         │ │
│  │  ┌─────────────────┐  ┌─────────────────┐              │ │
│  │  │ devops-app-     │  │ devops-app-     │              │ │
│  │  │ terraform-      │  │ terraform-      │              │ │
│  │  │ state-qa        │  │ state-test      │              │ │
│  │  └─────────────────┘  └─────────────────┘              │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │                 DynamoDB Tables                          │ │
│  │                                                         │ │
│  │  ┌─────────────────┐  ┌─────────────────┐              │ │
│  │  │ terraform-      │  │ terraform-      │              │ │
│  │  │ lock-prod       │  │ lock-staging    │              │ │
│  │  └─────────────────┘  └─────────────────┘              │ │
│  │                                                         │ │
│  │  ┌─────────────────┐  ┌─────────────────┐              │ │
│  │  │ terraform-      │  │ terraform-      │              │ │
│  │  │ lock-qa         │  │ lock-test       │              │ │
│  │  └─────────────────┘  └─────────────────┘              │ │
│  └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Application Secrets Management
```
┌─────────────────────────────────────────────────────────────────┐
│                 AWS Systems Manager                             │
│                  Parameter Store                                │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              SecureString Parameters                       │ │
│  │                                                           │ │
│  │  /devops-app/prod/app-secret     (Encrypted)             │ │
│  │  /devops-app/staging/app-secret  (Encrypted)             │ │
│  │  /devops-app/qa/app-secret       (Encrypted)             │ │
│  │  /devops-app/test/app-secret     (Encrypted)             │ │
│  │                                                           │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 🔒 Security Architecture

### Network Security
```
┌─────────────────────────────────────────────────────────────────┐
│                    Security Groups                              │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              ECS Tasks Security Group                      │ │
│  │                                                           │ │
│  │  Inbound Rules:                                           │ │
│  │  ├─ Port 80   (HTTP)   from 0.0.0.0/0                    │ │
│  │  └─ Port 443  (HTTPS)  from 0.0.0.0/0                    │ │
│  │                                                           │ │
│  │  Outbound Rules:                                          │ │
│  │  └─ All traffic to 0.0.0.0/0                             │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### IAM & Access Control
```
┌─────────────────────────────────────────────────────────────────┐
│                      IAM Architecture                           │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                    ECS Task Role                           │ │
│  │                                                           │ │
│  │  Permissions:                                             │ │
│  │  ├─ SSM Parameter Store (Read)                            │ │
│  │  ├─ CloudWatch Logs (Write)                               │ │
│  │  └─ ECR (Pull Images)                                     │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                  ECS Execution Role                       │ │
│  │                                                           │ │
│  │  Permissions:                                             │ │
│  │  ├─ ECR (Pull Images)                                     │ │
│  │  ├─ CloudWatch Logs (Create/Write)                        │ │
│  │  └─ SSM Parameter Store (Read)                            │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 🏷️ Resource Naming & Tagging

### Naming Convention
```
Resource Naming Pattern: ${project_name}-${environment}-${resource_type}

Examples:
├─ VPC:              devops-app-prod-vpc
├─ ECS Cluster:      devops-app-prod-ecs-cluster
├─ Security Group:   devops-app-prod-ecs-tasks-sg
├─ SSM Parameter:    /devops-app/prod/app-secret
└─ S3 Bucket:        devops-app-terraform-state-prod
```

### Tagging Strategy
```yaml
Common Tags:
  Environment:   prod | staging | qa | test
  Project:       devops-app
  Owner:         devops-team
  CreatedBy:     terraform
  ManagedBy:     terraform
  Application:   app
```

## 📊 Environment Matrix

| Environment | VPC CIDR      | State Bucket                      | DynamoDB Table         |
|-------------|---------------|-----------------------------------|------------------------|
| **Test**    | 10.3.0.0/16   | devops-app-terraform-state-test   | terraform-lock-test    |
| **QA**      | 10.1.0.0/16   | devops-app-terraform-state-qa     | terraform-lock-qa      |
| **Staging** | 10.2.0.0/16   | devops-app-terraform-state-staging| terraform-lock-staging |
| **Prod**    | 10.0.0.0/16   | devops-app-terraform-state-prod   | terraform-lock-prod    |

## 🔄 Data Flow Architecture

### Application Request Flow
```
┌─────────────────────────────────────────────────────────────────┐
│                    Request Flow                                 │
│                                                                 │
│ Internet ─┐                                                     │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────┐                                           │
│  │ Internet Gateway │                                           │
│  └─────────────────┘                                           │
│           │                                                     │
│           ▼                                                     │
│  ┌─────────────────┐     ┌─────────────────┐                   │
│  │ Application     │────▶│ ECS Tasks       │                   │
│  │ Load Balancer   │     │ (Flask App)     │                   │
│  │ (Future)        │     │ Port: 5000      │                   │
│  └─────────────────┘     └─────────────────┘                   │
│                                   │                             │
│                                   ▼                             │
│                          ┌─────────────────┐                   │
│                          │ SSM Parameter   │                   │
│                          │ Store           │                   │
│                          │ (App Secrets)   │                   │
│                          └─────────────────┘                   │
└─────────────────────────────────────────────────────────────────┘
```

## 🚀 Deployment Architecture

### Multi-Environment Pipeline Flow
```
┌─────────────────────────────────────────────────────────────────┐
│                 Environment Promotion Flow                      │
│                                                                 │
│ ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐   │
│ │   Test   │───▶│    QA    │───▶│ Staging  │───▶│   Prod   │   │
│ │          │    │          │    │          │    │          │   │
│ │ • Manual │    │ • Manual │    │ • Auto   │    │ • Manual │   │
│ │ • Fast   │    │ • Review │    │ • Review │    │ • Review │   │
│ └──────────┘    └──────────┘    └──────────┘    └──────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## 📈 Scalability & Performance

### Auto Scaling Configuration
```yaml
ECS Service Configuration:
  Desired Count: 1-10 tasks
  Min Capacity: 1
  Max Capacity: 10
  Target CPU: 70%
  Target Memory: 80%

Task Definition:
  CPU: 256 (0.25 vCPU)
  Memory: 512 MB
  Network Mode: awsvpc
```

## 🔍 Monitoring & Observability

### Monitoring Stack
```
┌─────────────────────────────────────────────────────────────────┐
│                  Monitoring Architecture                        │
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐                     │
│  │   CloudWatch    │    │   Application   │                     │
│  │     Logs        │◄───│     Logs        │                     │
│  └─────────────────┘    └─────────────────┘                     │
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐                     │
│  │   CloudWatch    │    │   ECS Service   │                     │
│  │    Metrics      │◄───│    Metrics      │                     │
│  └─────────────────┘    └─────────────────┘                     │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              Local Development Stack                       │ │
│  │                                                           │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │ │
│  │  │ Prometheus  │  │   Grafana   │  │    Redis    │       │ │
│  │  │  (Metrics)  │  │ (Dashboard) │  │  (Caching)  │       │ │
│  │  └─────────────┘  └─────────────┘  └─────────────┘       │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 🔧 Infrastructure Components

### Core Modules
1. **Network Module**: VPC, Subnets, IGW, Route Tables
2. **ECS Module**: ECS Cluster, Security Groups, Task Definitions
3. **SSM Module**: Parameter Store for secrets management

### Terraform Structure
```
infra/
├── main.tf              # Main configuration & module calls
├── provider.tf          # AWS provider configuration
├── deploy.sh           # Deployment automation script
├── envs/               # Environment-specific configurations
│   ├── prod/           # Production environment
│   ├── staging/        # Staging environment
│   ├── qa/            # QA environment
│   └── test/          # Test environment
└── modules/           # Reusable Terraform modules
    ├── network/       # VPC and networking resources
    ├── ecs/          # ECS cluster and services
    └── ssm/          # Parameter Store and secrets
```

This architecture provides a robust, scalable, and secure foundation for your DevOps application with proper environment isolation, security controls, and deployment automation.