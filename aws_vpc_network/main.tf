data "aws_ami" "ubuntu" {
  count       = var.ami_id == "" ? 1 : 0
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  selected_ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu[0].id
}

resource "aws_vpc" "vpclab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, {
    Name = "vpclab"
  })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpclab.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "VPCLabPub"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpclab.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name = "VPCLabPri"
    Tier = "private"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpclab.id

  tags = merge(var.common_tags, {
    Name = "VPCLabIGW"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpclab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, {
    Name = "VPCLabPublicRT"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "VPCLabNATEIP"
  })
}

resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public.id

  tags = merge(var.common_tags, {
    Name = "VPCLabNAT"
  })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpclab.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat[0].id
    }
  }

  tags = merge(var.common_tags, {
    Name = "VPCLabPrivateRT"
  })
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public_ec2" {
  name        = "VPCLabSGPub"
  description = "Allow SSH to the public EC2 from my IP only"
  vpc_id      = aws_vpc.vpclab.id

  ingress {
    description = "SSH from my IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "VPCLabSGPub"
  })
}

resource "aws_security_group" "private_ec2" {
  name        = "VPCLabSGPri"
  description = "Allow SSH to private EC2 only from the public EC2 security group"
  vpc_id      = aws_vpc.vpclab.id

  ingress {
    description     = "SSH from public EC2 security group only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "VPCLabSGPri"
  })
}

resource "aws_instance" "public" {
  ami                         = local.selected_ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_ec2.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = merge(var.common_tags, {
    Name = "VPCLabEC2Pub"
  })
}

resource "aws_instance" "private" {
  ami                         = local.selected_ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private_ec2.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  tags = merge(var.common_tags, {
    Name = "VPCLabEC2Pri"
  })
}
