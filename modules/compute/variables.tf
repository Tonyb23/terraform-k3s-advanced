variable "project_name" {
    description = "Name prefix applied to all resources" 
    type = string
}

variable "environment" {
    description = "The deployment environment (dev, staging, prod)" 
    type = string
}

variable "instance_type" {
    description = "EC2 instance type" 
    type = string
}

variable "key_pair_name" {
    description = "Name of the EC2 key pair for SSH access" 
    type = string
}

variable "subnet_id" {
    description = "Subnet ID to launch the EC2 instance in" 
    type = string
}

variable "security_group_id" {
    description = "Security group ID to associate with the EC2 instance" 
    type = string
}

variable "volume_size" {
    description = "Root EBS volume Size in GB for the EC2 instance" 
    type = number
    default = 20
}

variable "install_k3s" {
    description = "Whether to install K3S on the EC2 instance on first boot" 
    type = bool
    default = true
}