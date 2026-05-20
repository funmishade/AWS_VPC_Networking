# AWS VPC Networking Lab — Public vs Private Subnet Architecture

## Project Overview

This project demonstrates how networking accessibility works inside AWS Virtual Private Clouds (VPCs).

The goal of this lab was not simply to create AWS resources, but to deeply understand:

* Why some resources are publicly accessible
* Why some resources remain private
* How route tables affect subnet behavior
* Why Internet Gateways matter
* Why NAT Gateways exist
* How bastion/public EC2 patterns work
* Why private OpenSearch domains cannot be accessed directly from the internet

This project recreates the exact networking behavior commonly used in production cloud environments.

---

# Architecture

```text
                    Internet
                        │
                ┌───────┴────────┐
                │ Internet Gateway│
                └───────┬────────┘
                        │
        ┌────────────────────────────────┐
        │             VPC                │
        │        10.0.0.0/16             │
        │                                │
        │   Public Subnet                │
        │   10.0.1.0/24                  │
        │        │                       │
        │        ▼                       │
        │   Public EC2                   │
        │   Has Public IP                │
        │                                │
        │                                │
        │   Private Subnet               │
        │   10.0.2.0/24                  │
        │        │                       │
        │        ▼                       │
        │   Private EC2                  │
        │   NO Public IP                 │
        │                                │
        └────────────────────────────────┘
```

---

# Objectives

The main objectives of this project were:

* Understand VPC networking fundamentals
* Understand public vs private subnets
* Understand route tables
* Understand Internet Gateway usage
* Understand why NAT Gateway exists
* Understand security groups
* Understand internal VPC communication
* Understand why private resources cannot be accessed publicly
* Relate the same concepts to private OpenSearch deployments

---

# Services Used

| Service             | Purpose                               | Free/Paid          |
| ------------------- | ------------------------------------- | ------------------ |
| VPC                 | Private cloud network                 | Free               |
| Subnets             | Network segmentation                  | Free               |
| Route Tables        | Traffic routing                       | Free               |
| Internet Gateway    | Public internet access                | Free               |
| Security Groups     | Traffic filtering                     | Free               |
| EC2                 | Compute instances                     | Free tier eligible |
| NAT Gateway         | Outbound internet for private subnets | Paid               |
| SSM Session Manager | Secure private access                 | Mostly free        |

---

# Project Tasks

## 1. Create VPC

Created a VPC with CIDR block:

```text
10.0.0.0/16
```

### Why?

The VPC defines the private network range used by all resources.

---

## 2. Create Public Subnet

Created subnet:

```text
10.0.1.0/24
```

### Why?

This subnet hosts internet-accessible resources.

---

## 3. Create Private Subnet

Created subnet:

```text
10.0.2.0/24
```

### Why?

This subnet isolates internal-only resources.

---

## 4. Create Internet Gateway

Created and attached an Internet Gateway to the VPC.

### Why?

The Internet Gateway allows traffic between the VPC and the public internet.

Without it:

```text
Internet
→ EC2
❌
```

---

## 5. Create Public Route Table

Added route:

```text
0.0.0.0/0 → Internet Gateway
```

Associated the route table with the public subnet.

### Important Lesson

A subnet becomes public because of its route table.

NOT because of its name.

### Meaning of the Route

```text
“All unknown traffic goes to the internet.”
```

---

## 6. Create Private Route Table

Created private route table.

Associated it with the private subnet.

### Optional NAT Gateway Route

If NAT Gateway exists:

```text
0.0.0.0/0 → NAT Gateway
```

### Important Lesson

NAT Gateway allows:

```text
Private EC2 → Internet ✅
```

But does NOT allow:

```text
Internet → Private EC2 ❌
```

---

# EC2 Deployment

## Public EC2

Created EC2 instance in public subnet.

### Configuration

* Public subnet selected
* Auto-assign public IP enabled
* Security group allowed SSH only from my public IP
* Key pair selected

### Why?

This EC2 acts as a public entry point into the VPC.

---

## Private EC2

Created EC2 instance in private subnet.

### Configuration

* Private subnet selected
* Auto-assign public IP disabled
* SSH allowed only from public EC2 security group
* Key pair selected

### Why?

This EC2 simulates private infrastructure such as:

* private OpenSearch
* internal databases
* internal application servers
* internal APIs

---

# Security Group Design

## Public EC2 Security Group

Allowed:

```text
SSH TCP 22
Source: My public IP only
```

### Why?

Restrict administrative access.

---

## Private EC2 Security Group

Allowed:

```text
SSH TCP 22
Source: Public EC2 security group
```

### Why?

Only internal trusted resources should access private systems.

This creates:

```text
Laptop → Private EC2 ❌
Public EC2 → Private EC2 ✅
```

---

# Testing Performed

## Test 1 — SSH into Public EC2

```text
Laptop → Public EC2 ✅
```

### Why it worked

* Public IP assigned
* Public subnet route to Internet Gateway
* Security group allowed SSH

---

## Test 2 — SSH directly into Private EC2

```text
Laptop → Private EC2 ❌
```

### Why it failed

* No public IP
* No public route
* Private subnet isolation

---

## Test 3 — SSH from Public EC2 into Private EC2

```text
Public EC2 → Private EC2 ✅
```

### Why it worked

Both instances are inside the same VPC.

AWS automatically creates a local VPC route:

```text
10.0.0.0/16 → local
```

This allows internal private communication.

---

# SSH Agent Forwarding

Used SSH agent forwarding to avoid copying private keys to EC2 instances.

### Flow

```text
Laptop (holds PEM key)
→ Public EC2
→ Private EC2
```

### Important Lesson

The private key should remain on the local machine whenever possible.

---

# Key Lessons Learned

## 1. Public IP alone does not make a resource public

A resource also needs:

* Internet Gateway
* Correct route table
* Security group access

---

## 2. Route tables define subnet behavior

Public/private behavior is determined by routing.

---

## 3. Security groups act as virtual firewalls

Traffic is controlled at the instance level.

---

## 4. Private resources are intentionally isolated

This is critical for:

* databases
* OpenSearch
* internal APIs
* sensitive systems

---

## 5. NAT Gateway does not make resources public

NAT only allows outbound internet access.

---

## 6. Internal VPC communication works through local routing

Resources inside the VPC can communicate privately.

---

## 7. This directly explains private OpenSearch behavior

The same networking principles apply to:

```text
Laptop → private OpenSearch ❌
EC2 inside VPC → private OpenSearch ✅
```

---

# Connection to Real-World Production Systems

This lab simulates common enterprise architecture patterns:

* Bastion host architecture
* Private OpenSearch deployments
* Internal databases
* Secure administration paths
* Segmented infrastructure
* Internal-only services

---

# Decisions Made

| Decision                 | Reason                           |
| ------------------------ | -------------------------------- |
| No NAT Gateway           | Avoid unnecessary cost           |
| Use private subnet       | Simulate real production systems |
| Restrict SSH to my IP    | Security best practice           |
| Use SG-to-SG rules       | Internal trust relationship      |
| Use SSH agent forwarding | Avoid copying PEM key            |

---

# Troubleshooting Encountered

## Problem 1 — SSH timeout

### Cause

Instance was inside a private subnet without internet routing.

### Fix

Created proper public subnet route:

```text
0.0.0.0/0 → Internet Gateway
```

---

## Problem 2 — PEM key permissions

### Cause

Windows file permissions were too open.

### Fix

Restricted file permissions using:

```powershell
icacls
```

---

## Problem 3 — PEM key not found on EC2

### Cause

The key existed only on the laptop.

### Fix

Used SSH agent forwarding.

---

# How This Relates to OpenSearch

This lab directly explains why private OpenSearch domains are inaccessible from local laptops.

Private OpenSearch behaves similarly to the private EC2 instance in this lab.

```text
Laptop
→ Private OpenSearch ❌

EC2 inside VPC
→ Private OpenSearch ✅
```

This explains why:

* SSM Session Manager works
* Bastion hosts exist
* NGINX reverse proxies exist
* VPNs are used
* PrivateLink exists

---

# Future Improvements

Potential future enhancements:

* Add NAT Gateway
* Add SSM Session Manager
* Add Bastion Host
* Add OpenSearch domain
* Add CloudWatch logging
* Add VPC Flow Logs
* Add Terraform implementation
* Add VPN access
* Add Lambda functions

---

# Final Takeaway

The most important lesson from this project:

```text
Cloud resource accessibility depends on network design,
not simply because the resource exists.
```

Understanding:

* routing
* subnet isolation
* internet access
* internal communication
* security groups

is foundational for:

* DevOps
* Cloud Engineering
* Security Engineering
* Observability
* SIEM architecture

---

# Suggested Repository Structure
will include this later

```
