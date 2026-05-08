output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.vpclab.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet."
  value       = aws_subnet.private.id
}

output "public_ec2_public_ip" {
  description = "Public IP address of the public EC2 instance."
  value       = aws_instance.public.public_ip
}

output "public_ec2_private_ip" {
  description = "Private IP address of the public EC2 instance."
  value       = aws_instance.public.private_ip
}

output "private_ec2_private_ip" {
  description = "Private IP address of the private EC2 instance."
  value       = aws_instance.private.private_ip
}

output "ssh_to_public_ec2" {
  description = "SSH command to connect from your laptop to the public EC2."
  value       = "ssh -i <your-key.pem> ubuntu@${aws_instance.public.public_ip}"
}

output "ssh_from_public_to_private_ec2" {
  description = "SSH command to run from the public EC2 to reach the private EC2."
  value       = "ssh ubuntu@${aws_instance.private.private_ip}"
}

output "nat_gateway_enabled" {
  description = "Shows whether NAT Gateway was enabled for the private subnet."
  value       = var.enable_nat_gateway
}
