resource "aws_ssm_parameter" "app_secret" {
  name  = var.parameter_name
  type  = "SecureString"
  value = var.app_secret

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-app-secret"
  })
}