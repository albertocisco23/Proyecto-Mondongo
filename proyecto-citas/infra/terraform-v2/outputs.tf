output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "Public URL to access the API"
}

output "rds_endpoint" {
  value       = aws_db_instance.postgres.address
  description = "RDS endpoint (private)"
}

output "db_secret_arn" {
  value       = aws_secretsmanager_secret.db_secret.arn
  description = "Secrets Manager ARN with DB credentials"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.api.name
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.api_logs.name
}