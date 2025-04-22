# ----------------------------
# General Information
# ----------------------------

# Output the AWS region in which resources are deployed
output "region" {
  description = "The AWS region where resources are deployed"
  value       = var.region
}

# Output the project name
output "project_name" {
  description = "The project name"
  value       = var.project_name
}

# ----------------------------
# Networking Outputs
# ----------------------------

# Output the VPC ID created
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

# Output the list of public subnet IDs
output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnet_ids
}

# Output the CIDR blocks of public subnets
output "public_subnet_cidr" {
  description = "CIDR blocks of public subnets"
  value       = module.networking.public_subnet_cidr
}

# Output the list of App private subnet IDs
output "app_subnets" {
  description = "List of private subnet IDs"
  value       = module.networking.app_subnet_ids
}

# Output the CIDR blocks of App private subnets
output "app_subnet_cidr" {
  description = "CIDR blocks of App private subnets"
  value       = module.networking.app_subnet_cidr
}

# Output the list of DB private subnet IDs
output "db_subnets" {
  description = "List of private subnet IDs"
  value       = module.networking.db_subnet_ids
}

# Output the CIDR blocks of DB private subnets
output "db_subnet_cidr" {
  description = "CIDR blocks of DB private subnets"
  value       = module.networking.db_subnet_cidr
}

# Output the Elastic IP in the Networking Module
output "nat_eip" {
  description = "Elastic IP in the Networking Module"
  value       = module.networking.nat_eip
}

# Output NAT ID in the Networking Module
output "nat_id" {
  description = "NAT ID in the Networking Module"
  value       = module.networking.nat_id
}

# Output Public Route Table ID in the Networking Module
output "public_rt_id" {
  description = "Public Route Table ID in the Networking Module"
  value       = module.networking.public_rtb_id
}

# Output Private Route Table ID in the Neworking Module
output "private_rt_id" {
  description = "Private Route Table ID in the Networking Module"
  value       = module.networking.private_rtb_id
}

# ----------------------------
# Security Group Outputs
# ----------------------------

# Output the RDS Security Group ID
output "rds_sg_id" {
  description = "Security Group ID for the RDS Instance"
  value       = module.security.rds_id
}

# Output ALB Security Group ID
output "alb_sg_id" {
  description = "Security Group ID for ALB"
  value       = module.security.alb_sg_id
}

# Output Admin Security Group ID
output "admin_sg_id" {
  value = module.security.admin_sg_id
}

# Output Kafka SG ID
output "kafka_sg_id" {
  value = module.security.kafka_sg_id
}

# Output Elasticache SG ID
output "elasticache_sg_id" {
  value = module.security.elasticache_sg_id
}

# ----------------------------
# Load Balancer Outputs
# ----------------------------

# Output the DNS name of the ALB
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.load_balancer.alb_dns_name
}

# ----------------------------
# Database (RDS) Outputs
# ----------------------------

# Output the endpoint of the RDS instance
output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.rds_endpoint
}

# Output the username used by the RDS instance
output "rds_username" {
  description = "RDS database port"
  value       = module.database.rds_username
  sensitive = true
}

# Output the password used by the RDS instance
output "rds_password" {
  description = "RDS database password"
  value       = module.database.rds_password
  sensitive = true
}

# ----------------------------
# Compute (EC2) Outputs
# ----------------------------

# Output the Hostname of EC2 instances created
output "ec2_instance_hostname" {
  description = "List of EC2 instance IDs"
  value       = module.compute.admin_server_name
}

# Output the private IPs of EC2 instances
output "ec2_private_ip" {
  description = "Private IP addresses of EC2 instances"
  value       = module.compute.admin_private_ip
}

# Output theID of the EC2 Instance Created
output "ec2_instance_id" {
  description = "List of EC2 instance IDs"
  value       = module.compute.admin_instance_id
}




# ----------------------------
# IAM Outputs
# ----------------------------

# Output the IAM instance profile ARN used by EC2
output "instance_profile_arn" {
  description = "IAM instance profile attached to EC2 instances"
  value       = module.iam.admin_instance_profile_arn
}


# ----------------------------
# ElastiCache Outputs
# ----------------------------

# Output the Redis endpoint
output "redis_endpoint" {
  description = "Endpoint address of ElastiCache Redis"
  value       = module.services.redis_endpoints
}

# ----------------------------
# Kafka (MSK) Outputs
# ----------------------------

# Output the bootstrap broker endpoints for MSK
output "msk_bootstrap_brokers" {
  description = "Bootstrap broker string for Kafka MSK cluster"
  value       = module.services.msk_bootstrap_brokers_plaintext
}

# Output the MSK cluster bootstrap brokers for TLS connections
output "msk_bootstrap_brokers_tls" {
  value = module.services.msk_bootstrap_brokers_tls
}

# Output the MSK cluster bootstrap brokers for SASL SCRAM authentication
output "msk_bootstrap_brokers_sasl_scram" {
  value = module.services.msk_bootstrap_brokers_sasl_scram
}