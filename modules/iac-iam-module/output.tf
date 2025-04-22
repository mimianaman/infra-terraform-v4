# Output Admin Instance Profile ARN
output "admin_instance_profile_arn" {
  value = aws_iam_instance_profile.admin_profile.arn
}

