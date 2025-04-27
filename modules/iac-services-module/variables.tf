# Variables for Security Module

# Region
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

# Managed By
variable "managed_by" {
  description = "Managed by information"
  type        = string
}

# Owner
variable "owner" {
  description = "Owner information"
  type        = string
}

# Environment
variable "environment" {
  description = "Environment name"
  type        = string
}

# Project Name
variable "project_name" {
  description = "Project name"
  type        = string
}

# Elasticache Node Type
variable "elasticache_node_type" {
  description = "Node type for the cluster"
  type        = string
}

variable "parameter_group_name" {
  description = "Parameter group name for the cluster"
  type        = string
}

variable "kafka_version" {
  description = "Engine version for the cluster"
  type        = string
}

# Kafka Instance Type
variable "kafka_instance_type" {
  description = "Kafka instance type"
  type        = string
}

# Kafka EBS Volume Size
variable "kafka_ebs_volume_size" {
  description = "EBS volume size for the Kafka cluster"
  type        = number
}

# Kafka Broker Nodes
variable "kafka_broker_nodes" {
  description = "Number of Broker Nodes for MSK Cluster"
  type        = number
}

# Parameter Group Family
variable "parameter_group_family" {
  description = "Parameter group family for the cluster"
  type        = string
}

# Valkey Parameter Group Family
variable "valkey_parameter_group_family" {
  description = "Parameter group family for the cluster"
  type        = string
}

# Elasticache Engine Version
variable "elasticache_engine_version" {
  description = "Engine version for the cluster"
  type        = string
}

# Elasticache Clusters
variable "num_cache_clusters" {
  description = "number of Elastic Cache Clusters"
  type        = number
}

# Redis Engine
variable "redis_engine" {
  description = "Cluster engine for the ElastiCache cluster"
  type        = string
}

# Valkey Engine
variable "valkey_engine" {
  description = "Cluster engine for the ElastiCache cluster"
  type        = string
}

variable "elasticache_port" {
  description = "Port for the ElastiCache cluster"
  type        = number
}

# Availability Zones Count
variable "availability_zones_count" {
  description = "Number of AZs to use"
  type        = number
}