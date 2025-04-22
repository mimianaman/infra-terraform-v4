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
  admin_profile_name          = "${local.name_prefix}-admin-profile"
  app_profile_name            = "${local.name_prefix}-app-profile"
  admin_role_name             = "${local.name_prefix}-admin-role"
  app_role_name               = "${local.name_prefix}-app-role"
  app_s3_policy_name          = "${local.name_prefix}-app-s3-policy"
  ec2_assume_role_policy_name = "${local.name_prefix}-ec2-assume-role-policy"
}

###############################################################################

# Create a Data Source for EC2 Trust Policy
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#############################################################################

# Create IAM roles and policies for EC2 instances
# This module creates IAM roles and policies for EC2 instances

# Create Admin Role
resource "aws_iam_role" "admin_role" {
  name               = "admin-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Attach AWS-managed policies
resource "aws_iam_role_policy_attachment" "admin_managed_ssm" {
  for_each = toset([
    var.iam_ssm_fullaccess_policy_arn,
    var.iam_ssm_maintenance_window_policy_arn,
    var.iam_ssm_managed_instance_core_policy_arn,
    var.iam_ec2_ssm_policy_arn,
    var.aws_budgets_actions_with_ssm_policy_arn,
  ])

  role       = aws_iam_role.admin_role.name
  policy_arn = each.value
}

# Create instance profile for the admin role
resource "aws_iam_instance_profile" "admin_profile" {
  name = local.admin_profile_name
  role = aws_iam_role.admin_role.name
}