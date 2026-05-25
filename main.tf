# ── Terraform Provider configuration ─────────────────────────────────
# Tell Terraform which provider to use and what version.
# The AWS provider is the plugin that lets Terraform talk to AWS. 
terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  #S3 remote backend
  #This replaces thelocal terraform.tfstate file.
  #All team members and CI/CD pipelines share this state.
  backend "s3" {
    bucket = "terraform-state-tonyb"
    key = "terraform-k3s/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true # Enable state locking to prevent concurrent modifications/ replaces dynamoDB tablelocking
    encrypt = true
  }
}

# ── AWS Provider configuration ───────────────────────────────────────
# Configure the AWS provider with your credentials and region.
provider "aws" {
  # The region where your AWS resources will be created.
  region = var.aws_region
}

# ── Networking Module ─────────────────────────────────────────
# Calls the networking module and passes in the required inputs.
# The module creates the VPC, subnet, internet gateway,
# route table, and security group.

module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  environment = var.environment
  aws_region = var.aws_region
  vpc_cidr = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

# ── Compute Module ─────────────────────────────────────────
# Calls the Compute module and passes in the required inputs.
# Notice how subnet_id and security_group_id come from the
# networking module outputs — this is how modules connect.

module "compute" {
  source = "./modules/compute"

  project_name = var.project_name
  environment = var.environment
  instance_type = local.instance_type
  key_pair_name = var.key_pair_name
  subnet_id = module.networking.subnet_id
  security_group_id = module.networking.security_group_id
  volume_size = local.volume_size
  install_k3s = var.install_k3s
}