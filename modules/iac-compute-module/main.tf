# Select latest available version of Ubuntu OS for use as a base image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Fetch Admin SG ID from SSM Parameter Store
data "aws_ssm_parameter" "admin_sg_id" {
  name = "/${local.name_prefix}/admin_sg_id"
}

# Fetch Private Subnet IDs from SSM Parameter Store
data "aws_ssm_parameter" "app_private_subnet_ids" {
  name = "/${local.name_prefix}/app_subnet_ids"
}

data "aws_iam_instance_profile" "admin_profile" {
  name = "${local.name_prefix}-admin-profile"
}

###############################################################################

# Local Variables for Naming Conventions
locals {
  # Naming convention for resources
  name_prefix = "${terraform.workspace}-${var.project_name}-${var.region}"

  # Common tags for all resources
  common_tags = {
    Environment = terraform.workspace
    Managed_by  = var.managed_by
    Owner       = var.owner
    Project     = "${var.project_name}"
  }
}

# Local variables for resource names
locals {
  instance_name     = "${local.name_prefix}-app-server"
  admin_server_name = "${local.name_prefix}-admin-server"
  asg_name          = "${local.name_prefix}-asg"
}

###############################################################################

# Admin EC2 Instance
resource "aws_instance" "admin" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.ec2_instance_type
  subnet_id            = split(",", data.aws_ssm_parameter.app_private_subnet_ids.value)[0]
  iam_instance_profile = data.aws_iam_instance_profile.admin_profile.name
  security_groups      = [data.aws_ssm_parameter.admin_sg_id.value]

  lifecycle {
    ignore_changes = [
    security_groups]
  }

  tags = merge(local.common_tags,
    {
      Name = "${local.admin_server_name}"
  })
}

