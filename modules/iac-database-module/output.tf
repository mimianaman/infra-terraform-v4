# Output RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

# Output RDS username
output "rds_username" {
  value = aws_db_instance.rds.username
  sensitive = true
}

# Output RDS password
output "rds_password" {
  value = aws_db_instance.rds.password
  sensitive = true
}