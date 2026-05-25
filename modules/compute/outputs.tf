output "public_ip" {
    description = "The public IP of the EC2 instance"
    value = aws_instance.k3s-server.public_ip
}

output "instance_id" {
    description = "The ID of the EC2 instance"
    value = aws_instance.k3s-server.id
}

output "private_ip" {
    description = "The private IP of the EC2 instance"
    value = aws_instance.k3s-server.private_ip
}