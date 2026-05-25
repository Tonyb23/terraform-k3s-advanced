variable "aws_region" {
    description = "AWS region to deploy into"
    type = string
    default = "us-east-1"
}

variable "project_name" {
    description = "Name Prefix for all resources"
    type = string
    default = "terraform-k3s"
}

variable "environment" {
    description = "Deployment environment (e.g., dev, staging, prod)"
    type = string
    default = "dev"
}

variable "key_pair_name" {
    description = "AWS EC2 Key Pair name for SSH access"
    type = string
    default = "ubuntu-ec2-key"
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    description = "CIDR block for the subnet"
    type = string
    default = "10.0.1.0/24"
}


variable "install_k3s" {
    description = "install K3S on the instances at boot time"
    type = bool
    default = true
}