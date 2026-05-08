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
