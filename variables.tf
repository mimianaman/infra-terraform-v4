# Project Name
variable "project_name" {
  description = "Name of the project"
  type        = string
}

# Owner of the resource
variable "owner" {
  description = "Owner of the resource"
  type        = string
}

# AWS Region
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

# Environment
variable "environment" {
  description = "Environment name"
  type        = string
}

# Resource Manager
variable "managed_by" {
  description = "Managed by information"
  type        = string
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

# Allowed CIDR Blocks
variable "allowed_cidr_blocks" {
  description = "Allowed CIDR Blocks"
  type        = list(string)
}

# Public Route
variable "public_route_table_destination_cidr" {
  description = "Destination CIDR block for public subnet route table"
  type        = string
}

# Availability Zones Count
variable "availability_zones_count" {
  description = "Number of availability zones"
  type        = number
}

# SSH Port
variable "ssh_port" {
  description = "value of ssh port"
  type        = number
}

# My IP
variable "my_ip" {
  description = "value of my ip"
  type        = string
}

# HTTP Port
variable "http_port" {
  description = "value of http port"
  type        = number
}

# HTTPS Port
variable "https_port" {
  description = "value of https port"
  type        = number
}

# Public Destination CIDR
variable "public_destination_cidr" {
  description = "value of public destination cidr"
  type        = string
}

# MySQL Port
variable "mysql_port" {
  description = "value of mysql port"
  type        = number
}

# Postgres Port
variable "postgres_port" {
  description = "value of postgres port"
  type        = number
}

# Redis Port
variable "redis_port" {
  description = "value of redis port"
  type        = number
}

# Kafka Port
variable "kafka_port" {
  description = "value of kafka port"
  type        = number
}

# SSM Full Access Policy ARN
variable "ssm_fullaccess_policy_arn" {
  description = "Amazon SSM Full Access policy ARN"
  type        = string
}

# SSM Maintenance Window Policy ARN
variable "ssm_maintenance_window_policy_arn" {
  description = "Amazon SSM Maintenance policy ARN"
  type        = string
}

# SSM Managed Instance Core Policy ARN
variable "ssm_managed_instance_core_policy_arn" {
  description = "Amazon SSM Managed Instance Core policy ARN"
  type        = string
}

# EC2 SSM Policy ARN
variable "iam_ec2_ssm_policy_arn" {
  description = "Amazon EC2 Role for SSM policy ARN"
  type        = string
}

# AWS Budgets Actions Role Policy for Resource Administration with SSM ARN
variable "aws_budgets_actions_with_ssm_policy_arn" {
  description = "AWS Budgets Actions Role Policy for Resource Administration with SSM ARN"
  type        = string
}

# EC2 Access Policy ARN
variable "ec2_full_access_policy_arn" {
  description = "EC2 access policy ARN"
  type        = string
}

# RDS Access Policy ARN
variable "rds_full_access_policy_arn" {
  description = "RDS access policy ARN"
  type        = string
}

# Health Check Port
variable "health_check_port" {
  description = "Port for health check"
  type        = number
}

# Health Check Protocol
variable "health_check_protocol" {
  description = "Protocol for health check"
  type        = string
}

# ALB Type
variable "alb_type" {
  description = "Type of the ALB"
  type        = string
}

# Target Type
variable "target_type" {
  description = "Target type for the ALB"
  type        = string
}

# Health Check Variables
variable "health_check" {
  type = object({
    path                = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
}

# Instance Type
variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

# Container Port
variable "container_port" {
  description = "Port for the container"
  type        = number
}

# App Version
variable "app_version" {
  description = "The version of the application"
  type        = string
  default     = "1.0.0"
}

# Task Definition CPU
variable "task_cpu" {
  description = "CPu allocation for Task Definition"
  type = number
}

# Memory Allocation for Task Definition
variable "task_memory" {
  description = "Memory allocation for Task Definition"
  type = number
}

# Container User
variable "container_user" {
  description = "User for the container"
  type = string
}

# ECS Maximum Capacity
variable "ecs_max_capacity" {
  description = "Maximum capacity for the ECS cluster"
  type = number
}

# CPU Target Value
variable "cpu_target_value" {
  description = "Target value for CPU utilization"
  type = number
}

# Memory Target Value
variable "memory_target_value" {
  description = "Target value for memory utilization"
  type = number
}

# # DB Instance Class
# variable "db_instance_class" {
#   description = "DB instance class"
#   type        = string
# }

# # DB Storage Size
# variable "db_storage_size" {
#   description = "DB storage size in GB"
#   type        = number
# }

# # DB Engine
# variable "db_engine" {
#   description = "DB engine"
#   type        = string
# }

# # DB Username
# variable "db_username" {
#   description = "Username for the database"
#   type        = string
# }

# # EC2 Instance Count
# variable "ec2_instance_count" {
#   description = "Number of EC2 instances"
#   type        = number
# }

# # Elasticache Node Type
# variable "elasticache_node_type" {
#   description = "Node type for the cluster"
#   type        = string
# }

# # Parameter Group Name
# variable "elasticache_parameter_group_name" {
#   description = "Parameter group name for the cluster"
#   type        = string
# }

# # Kafka Version
# variable "kafka_version" {
#   description = "Engine version for the cluster"
#   type        = string
# }

# # AWS ElastiCache Engine
# variable "elasticache_engine" {
#   description = "Cluster engine for the ElastiCache cluster"
#   type        = string
# }

# # ElastiCache Port
# variable "elasticache_port" {
#   description = "Port for the ElastiCache cluster"
#   type        = number
# }

# # Kafka Port
# variable "kafka_port" {
#   description = "Kafka port"
#   type        = number
# }

# # Kafka Instance Type
# variable "kafka_instance_type" {
#   description = "Kafka instance type"
#   type        = string
# }

# # DB name
# variable "db_name" {
#   description = "Database name"
#   type        = string
# }