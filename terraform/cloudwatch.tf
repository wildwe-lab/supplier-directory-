resource "aws_cloudwatch_log_group" "frontend-logs" {
  name              = "/ecs/supplier-directory/frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend-logs" {
  name              = "/ecs/supplier-directory/backend"
  retention_in_days = 7
}