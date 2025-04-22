# Output Admin Instance DNS Name
output "admin_server_name" {
  value = aws_instance.admin.private_dns
}

# Output Admin Instance Private IP
output "admin_private_ip" {
  value = aws_instance.admin.private_ip
}

# Out Put Admin Instance ID
output "admin_instance_id" {
  value = aws_instance.admin.id
}