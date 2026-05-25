# ── Data Source: Ubuntu AMI ─────────────────────────────────── 
# This looks up the latest Ubuntu 22.04 AMI in your region.
# We use data sources to read existing information from AWS without creating anything.
# 099720109477 is Canonical's (the makers of Ubuntu) AWS account ID. 
data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

# ── EC2 Instance ───────────────────────────────────────────── 
# The actual Ubuntu server.
# user_data is a script that runs once when the server first boots.
# We use it to install K3s automatically so no manual setup is needed. 

locals {
    # This script runs on first boot — installs K3s automatically.
    # <<-EOF ... EOF is a multi-line string in Terraform (heredoc syntax). 
    k3s_user_data = <<-EOF
      #!/bin/bash
      set -euo pipefail

      # Update package lists
      apt-get update -y
      
      # Install curl (Needed to download K3s install script)
      apt-get install -y curl

      # Install K3s using the official install script, installs and starts the service
      curl -sfL https://get.k3s.io | sh -
      
      # Make the kubeconfig readable by the ubuntu user (not just root)
      chmod 644 /etc/rancher/k3s/k3s.yaml
      
      # Add KUBECONFIG to ubuntu user profile so kubectl works on login
      echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /home/ubuntu/.bashrc
    EOF
}

resource "aws_instance" "k3s-server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]
    associate_public_ip_address = true
    key_name = var.key_pair_name

    # Conditionally install K3s based on the "install_k3s" variable.
    user_data = var.install_k3s ? local.k3s_user_data : null  

    # Give the instance a larger root volume so we have space for K3s and any apps we deploy.
    root_block_device {
        volume_size = var.volume_size
        volume_type = "gp3"
    }

    tags = {
        Name = "${var.project_name}-${var.environment}-server"
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}