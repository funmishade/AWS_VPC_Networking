# Project - VPC on the Console

No matter how small, I will be updating my GitHub and profile with the task.

## Tasks Completed

- Create VPC with a CIDR of `10.0.0.0/16`
- Create 2 subnets:
  - `10.0.1.0/24`
  - `10.0.2.0/24`
- Create the Internet Gateway and attach it to the VPC
- Create public route table
- Add route:

```text
0.0.0.0/0 → Internet Gateway
```

- Associate the public subnet to this public route table

This is indeed what makes a subnet public: the route attached to it.

```text
“All unknown traffic goes to the internet.”
```

- Create private route table
- Add route:

```text
0.0.0.0/0 → NAT Gateway
```

if you have NAT Gateway created, and associate it with the private subnet.

- Associate the private subnet to this private route table

## Public EC2 Instance

Create an EC2 instance:

- Select key pair
- Select public subnet
- Security group should allow SSH on port `22` from my IP only
- Enable auto-assign public IP

## Private EC2 Instance

Create another EC2 instance:

- Select private subnet
- Select key pair
- Do not enable auto-assign public IP
- For security group, allow SSH only from the public EC2 security group

## Important Learning

Only instances using the public EC2 security group can SSH into the private EC2.

The private EC2 has no public IP, so nobody on the internet can directly SSH into it.

## Project Files

This repository includes:

- `README.md`
- `NOTES.md`
- `LESSONS_LEARNED.md`
- `DECISIONS_MADE.md`
- `TROUBLESHOOTING.md`

These files document what was done, what was learned, decisions made, and troubleshooting steps from the project.
