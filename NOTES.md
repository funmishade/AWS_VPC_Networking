# Notes

## VPC

A VPC is a logically isolated private cloud network in AWS.

## Public Subnet

A subnet becomes public because its route table contains:

```text
0.0.0.0/0 → Internet Gateway
```

## Private Subnet

A private subnet does not have direct internet routing.

## NAT Gateway

NAT allows:

```text
Private EC2 → Internet ✅
```

But not:

```text
Internet → Private EC2 ❌
```

## Security Groups

Security groups filter traffic at the instance level.

## SSH Testing

```text
Laptop → Public EC2 ✅
Laptop → Private EC2 ❌
Public EC2 → Private EC2 ✅
```

---

## VPC — 6-Layer Mastery Framework

### Layer 1: What is a VPC?

A VPC is a logically isolated private cloud network in AWS.

### Layer 2: What problem does it solve?

It isolates systems and controls network communication securely.

### Layer 3: Why was it needed?

Organizations need private networking, traffic control, segmentation, and security boundaries in the cloud.

### Layer 4: What breaks without it?

Everything becomes publicly exposed, difficult to secure, and difficult to segment.

### Layer 5: How does it work internally?

A VPC works through several networking components:

- CIDR
- Subnets
- Route tables
- Public vs private subnet design
- Internet Gateway
- NAT Gateway
- Security groups

### Layer 6: Real production usage

A common production example is a private OpenSearch domain deployed inside private subnets within a VPC.

```text
Private OpenSearch
→ inside private subnets
→ inside a VPC
→ accessible only from internal resources
```

This explains why a laptop cannot directly access private OpenSearch, but an EC2 instance, SSM session, bastion host, or CI/CD runner inside the VPC can.
