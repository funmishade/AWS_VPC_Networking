# AWS VPC Networking Lab - Terraform

This Terraform lab builds a simple VPC with one public subnet, one private subnet, a public EC2 instance, and a private EC2 instance.

## Architecture

```text
Your laptop
  |
  | SSH using PEM key
  v
Public EC2: VPCLabEC2Pub
  |
  | SSH over private VPC network
  v
Private EC2: VPCLabEC2Pri
```

## What this creates

- VPC: `vpclab` with CIDR `10.0.0.0/16`
- Public subnet: `VPCLabPub` with CIDR `10.0.1.0/24`
- Private subnet: `VPCLabPri` with CIDR `10.0.2.0/24`
- Internet Gateway: `VPCLabIGW`
- Public route table: `VPCLabPublicRT`
- Private route table: `VPCLabPrivateRT`
- Public EC2 security group: `VPCLabSGPub`
- Private EC2 security group: `VPCLabSGPri`
- Public EC2 instance: `VPCLabEC2Pub`
- Private EC2 instance: `VPCLabEC2Pri`

## NAT Gateway setting

This lab sets NAT to false by default:

```hcl
enable_nat_gateway = false
```

That means the private subnet does not receive this route:

```text
0.0.0.0/0 -> NAT Gateway
```

The private EC2 has no public IP and no direct internet path.

## Security group behavior

The public EC2 allows SSH from your IP only:

```text
Your IP -> port 22 -> public EC2
```

The private EC2 allows SSH only from the public EC2 security group:

```text
Public EC2 security group -> port 22 -> private EC2
```

This means nobody on the internet can SSH directly into the private EC2.

## How to use

Copy the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

```hcl
key_name   = "OpenSearch"
my_ip_cidr = "YOUR_PUBLIC_IP/32"
```

Then run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

## How to connect

After apply, Terraform prints SSH commands in the outputs.

From your laptop:

```bash
ssh -i <your-key.pem> ubuntu@<public-ec2-public-ip>
```

From the public EC2:

```bash
ssh ubuntu@<private-ec2-private-ip>
```

If you do not copy the PEM file to the public EC2, use SSH agent forwarding from your laptop:

```bash
ssh-add <your-key.pem>
ssh -A ubuntu@<public-ec2-public-ip>
```

Then from the public EC2:

```bash
ssh ubuntu@<private-ec2-private-ip>
```

## Clean up

To avoid AWS charges:

```bash
terraform destroy
```
