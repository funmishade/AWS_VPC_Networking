# Troubleshooting

## SSH Timeout

### Cause

Instance was inside a private subnet without internet routing.

### Fix

Added:

```text
0.0.0.0/0 → Internet Gateway
```

to the public route table.

---

## PEM Key Permissions

### Cause

Windows permissions on PEM file were too open.

### Fix

Restricted permissions using:

```powershell
icacls
```

---

## PEM Key Not Found on EC2

### Cause

The key existed only on the laptop.

### Fix

Used SSH agent forwarding.
