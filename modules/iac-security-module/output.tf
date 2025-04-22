# Output SG IDS
# Output RDS SG ID
output "rds_id" {
  value = aws_security_group.rds_sg.id
}

# Output ALB SG ID
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

# Output Admin SG ID
output "admin_sg_id" {
  value = aws_security_group.admin_sg.id
}

# Output Kafka SG ID
output "kafka_sg_id" {
  value = aws_security_group.kafka_sg.id
}

# Output Elasticache SG ID
output "elasticache_sg_id" {
  value = aws_security_group.elasticache_sg.id
}