# Decisions Made

| Decision | Reason |
|---|---|
| No NAT Gateway | Avoid unnecessary cost |
| Use private subnet | Simulate real production systems |
| Restrict SSH to my IP | Security best practice |
| Use SG-to-SG rules | Internal trust relationship |
| Use SSH agent forwarding | Avoid copying PEM key |
