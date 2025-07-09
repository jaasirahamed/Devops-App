# CI/CD Pipeline Documentation

This document explains the separate CI/CD pipelines for application and infrastructure deployment.

## 🏗️ Pipeline Architecture

We have separated the CI/CD into three distinct workflows for better control and independence:

### 1. **Application Pipeline** (`app-pipeline.yml`)
- **Triggers**: Changes to `app/`, `Dockerfile`, `docker-compose.yml`
- **Purpose**: Test, build, and deploy application code
- **Environments**: Staging → Production

### 2. **Infrastructure Pipeline** (`infra-pipeline.yml`)
- **Triggers**: Changes to `infra/` directory
- **Purpose**: Validate, plan, and apply Terraform infrastructure
- **Environments**: Test → QA → Staging → Production

### 3. **Full Stack Deployment** (`full-stack-deploy.yml`)
- **Triggers**: Manual workflow dispatch only
- **Purpose**: Orchestrate both infrastructure and application deployments
- **Flexibility**: Choose what to deploy and to which environment

## 🚀 Workflow Triggers

### Automatic Triggers

**Application Pipeline**:
```yaml
on:
  push:
    branches: [ main, develop ]
    paths: [ 'app/**', 'Dockerfile', 'docker-compose.yml' ]
  pull_request:
    branches: [ main, develop ]
    paths: [ 'app/**', 'Dockerfile', 'docker-compose.yml' ]
```

**Infrastructure Pipeline**:
```yaml
on:
  push:
    branches: [ main, develop ]
    paths: [ 'infra/**' ]
  pull_request:
    branches: [ main, develop ]
    paths: [ 'infra/**' ]
```

### Manual Triggers

All pipelines support `workflow_dispatch` for manual execution with customizable parameters.

## 📋 Pipeline Features

### Application Pipeline Features

✅ **Smart Change Detection**: Only runs when app-related files change
✅ **Comprehensive Testing**: Unit tests, linting, security scans
✅ **Multi-Architecture Builds**: Supports AMD64 and ARM64
✅ **Environment Promotion**: Staging → Production flow
✅ **Health Checks**: Post-deployment validation
✅ **Coverage Reports**: Code coverage tracking

### Infrastructure Pipeline Features

✅ **Terraform Validation**: Format checking and validation
✅ **Security Scanning**: Checkov and TFSec integration
✅ **Environment Isolation**: Separate planning for each environment
✅ **Plan Artifacts**: Reusable Terraform plans
✅ **PR Comments**: Terraform plans in pull request comments
✅ **Destroy Capability**: Safe infrastructure destruction

## 🔧 Usage Examples

### 1. Deploy Only Application Changes

When you make changes to the application code:

```bash
# Changes in app/ directory automatically trigger:
git add app/
git commit -m "Update application logic"
git push origin main
```

**Result**: Only the application pipeline runs, skipping infrastructure.

### 2. Deploy Only Infrastructure Changes

When you modify Terraform configurations:

```bash
# Changes in infra/ directory automatically trigger:
git add infra/
git commit -m "Update VPC configuration"
git push origin main
```

**Result**: Only the infrastructure pipeline runs, skipping application.

### 3. Manual Full Stack Deployment

For coordinated deployments or specific environments:

1. Go to **Actions** tab in GitHub
2. Select **Full Stack Deployment**
3. Click **Run workflow**
4. Configure options:
   - **Environment**: Choose target environment
   - **Deploy Infrastructure**: Enable/disable
   - **Deploy Application**: Enable/disable
   - **Infrastructure Action**: plan/apply/destroy
   - **Skip Tests**: For emergency deployments
   - **Auto Approve**: For automated deployments

### 4. Emergency Production Deployment

```yaml
# Manual workflow dispatch with:
environment: production
deploy_infrastructure: false
deploy_application: true
skip_tests: false
auto_approve: false
```

### 5. Infrastructure-Only Update

```yaml
# Manual workflow dispatch with:
environment: staging
deploy_infrastructure: true
deploy_application: false
infrastructure_action: apply
auto_approve: true
```

## 🔒 Environment Protection

### Staging Environment
- **Auto-deploy**: On main branch pushes
- **Required reviewers**: None (for faster iteration)
- **Deployment timeout**: 30 minutes

### Production Environment
- **Auto-deploy**: After successful staging deployment
- **Required reviewers**: 2 team members
- **Deployment timeout**: 60 minutes
- **Restrict to protected branches**: main only

## 📊 Pipeline Flow Diagrams

### Application Pipeline Flow
```
Code Change (app/) → Test → Security Scan → Build → Deploy Staging → Deploy Production
                     ↓
                  Unit Tests
                  Linting
                  Safety Check
```

### Infrastructure Pipeline Flow
```
Code Change (infra/) → Validate → Security Scan → Plan Test → Plan Staging → Apply Staging → Plan Prod → Apply Prod
                       ↓
                    Format Check
                    TFLint
                    Terraform Validate
```

### Full Stack Flow
```
Manual Trigger → Infrastructure Pipeline (optional) → Application Pipeline (optional) → Notification
```

## 🔍 Monitoring & Notifications

### Pipeline Status Monitoring
- **GitHub Actions UI**: Real-time pipeline status
- **Email Notifications**: On pipeline failures
- **Slack Integration**: Success/failure notifications (configurable)

### Deployment Tracking
- **Artifact Storage**: Docker images with timestamps
- **Terraform Plans**: Stored as artifacts for review
- **Deployment History**: Full audit trail in GitHub Actions

## 🛠️ Customization

### Adding New Environments

1. **Create environment-specific files**:
   ```bash
   mkdir infra/envs/dev
   cp infra/envs/test/backend.tf infra/envs/dev/
   cp infra/envs/test/test.tfvars infra/envs/dev/dev.tfvars
   ```

2. **Update backend configuration**:
   ```hcl
   # infra/envs/dev/backend.tf
   terraform {
     backend "s3" {
       bucket = "devops-app-terraform-state-dev"
       key    = "dev/terraform.tfstate"
       # ...
     }
   }
   ```

3. **Add to pipeline workflows**:
   ```yaml
   # Add 'dev' to environment choices in workflow files
   options:
     - dev
     - test
     - qa
     - staging
     - production
   ```

### Modifying Deployment Logic

**Application Deployment**:
- Edit `app-pipeline.yml` deploy steps
- Customize health check logic
- Add post-deployment tests

**Infrastructure Deployment**:
- Modify Terraform validation rules
- Add custom security scans
- Configure additional approval steps

## 🚨 Troubleshooting

### Common Issues

**1. Pipeline Not Triggering**
- Check file paths in trigger conditions
- Verify branch protection rules
- Ensure correct file changes

**2. Terraform Plan Failures**
- Validate AWS credentials
- Check S3 bucket permissions
- Verify DynamoDB table access

**3. Docker Build Failures**
- Check Dockerfile syntax
- Verify base image availability
- Review dependency conflicts

**4. Deployment Timeouts**
- Increase timeout values in workflow
- Check AWS service limits
- Monitor resource utilization

### Debug Commands

```bash
# Test Terraform locally
cd infra
terraform init -backend-config=envs/staging/backend.tf
terraform plan -var-file=envs/staging/staging.tfvars

# Test application locally
docker-compose up --build

# Check pipeline logs
gh run list
gh run view <run-id>
```

## 📈 Best Practices

### Development Workflow

1. **Feature Branches**: Always work on feature branches
2. **Small Changes**: Keep commits focused and small
3. **Test Locally**: Test changes before pushing
4. **Review Plans**: Always review Terraform plans
5. **Monitor Deployments**: Watch pipeline execution

### Security Considerations

1. **Secrets Management**: Use GitHub Secrets for credentials
2. **Environment Isolation**: Separate AWS accounts per environment
3. **Access Control**: Limit who can deploy to production
4. **Audit Logging**: Monitor all deployment activities
5. **Vulnerability Scanning**: Regular security scans

### Performance Optimization

1. **Parallel Execution**: Leverage job parallelization
2. **Caching**: Use workflow caching for dependencies
3. **Artifact Reuse**: Reuse build artifacts across jobs
4. **Resource Limits**: Set appropriate timeouts and limits

## 📞 Support

For issues with the CI/CD pipelines:

1. **Check Pipeline Logs**: Review GitHub Actions logs
2. **Validate Locally**: Test changes on local environment
3. **Review Documentation**: Check this guide and README
4. **Contact Team**: Reach out to DevOps team for assistance