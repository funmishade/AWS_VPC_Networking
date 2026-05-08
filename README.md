# AWS VPC Networking Lab — Public vs Private Subnet Architecture

## Project Overview

This project demonstrates how networking accessibility works inside AWS Virtual Private Clouds (VPCs).

The goal of this lab was not simply to create AWS resources, but to deeply understand:

- Why some resources are publicly accessible
- Why some resources remain private
- How route tables affect subnet behavior
- Why Internet Gateways matter
- Why NAT Gateways exist
- How bastion/public EC2 patterns work
- Why private OpenSearch domains cannot be accessed directly from the internet

## Architecture

```text
Internet
   │
Internet Gateway
   │
VPC 10.0.0.0/16
├── Public Subnet 10.0.1.0/24
│    └── Public EC2
└── Private Subnet 10.0.2.0/24
     └── Private EC2
```

## Key Lessons

- Public IP alone does not make a resource public
- Route tables determine subnet behavior
- Private resources are intentionally isolated
- NAT Gateway does not make private resources publicly accessible
- Security groups act as virtual firewalls
- Internal VPC communication works through local routing

## Production Relevance

This lab directly explains:

```text
Laptop → Private OpenSearch ❌
EC2 inside VPC → Private OpenSearch ✅
```

Which is the same networking pattern used in real enterprise cloud environments.
