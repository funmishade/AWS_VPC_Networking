variable "aws_region" {
  description = "AWS region where the VPC lab will be created."
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Availability Zone for the public and private subnets. Example: us-east-1a."
  type        = string
  default     = "us-east-1a"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair to attach to both instances. Example: OpenSearch."
  type        = string
}

variable "my_ip_cidr" {
  description = "Your public IP address in CIDR format for SSH access to the public EC2. Example: 203.0.113.10/32."
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI ID for the selected AWS region. Leave empty to use the latest Ubuntu 22.04 LTS AMI found by Terraform."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type for the public and private instances."
  type        = string
  default     = "t2.micro"
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway and add a default internet route for the private subnet. For this lab, keep this false."
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags added to all supported resources."
  type        = map(string)
  default = {
    Project = "vpclab"
    ManagedBy = "terraform"
  }
}
