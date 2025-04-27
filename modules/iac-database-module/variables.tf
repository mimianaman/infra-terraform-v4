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

# DB Instance Class
variable "db_instance_class" {
  description = "DB instance class"
  type        = string
}

# DB Storage Size
variable "db_storage_size" {
  description = "DB storage size in GB"
  type        = number
}

# DB Engine
variable "mssql_db_engine" {
  description = "mssql DB engine"
  type        = string
}

# Username
variable "mysql_db_username" {
  description = "Username for the database"
  type        = string
}

# mssql DB Name
variable "mssql_db_name" {
  description = "Name of the database"
  type        = string
}

# Postgres DB Username
variable "postgres_db_username" {
  description = "Username for the database"
  type        = string
}

# Postgres DB Engine
variable "postgres_db_engine" {
  description = "Postgres DB engine"
  type        = string
}


# Postgres DB Name
variable "postgres_db_name" {
  description = "Name of the database"
  type        = string
}
