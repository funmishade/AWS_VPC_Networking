# Lessons Learned

## 1. Public IP alone does not make a resource publicly accessible

A resource also requires:

- Internet Gateway
- Correct route table
- Security group access

## 2. Route tables define subnet behavior

Public/private behavior depends on routing.

## 3. Security groups are critical

Security groups control allowed traffic.

## 4. Private resources are intentionally isolated

Used for:

- OpenSearch
- Databases
- Internal APIs
- Internal applications

## 5. Internal VPC communication uses local routing

AWS automatically creates:

```text
10.0.0.0/16 → local
```

allowing private communication within the VPC.
