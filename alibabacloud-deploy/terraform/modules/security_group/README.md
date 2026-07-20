# Terraform module: security_group

This module creates an AWS Security Group and supports adding ingress and egress rules.
It is designed to be reusable and to model both CIDR-based rules and rules that reference other security groups (source_security_group_id), matching patterns from your CloudFormation template.

Usage highlights:
- Provide name, vpc_id and tags
- Provide ingress rules as list of objects (supports cidr_blocks or source_security_group_id)
- Provide self_ingress_rules for allow-self rules (within same SG)
- Provide optional egress_rules (if empty default allow all egress will be created)

Example ingress rule object:

```hcl
ingress_rules = [
  {
    description = "HTTPS from anywhere"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "HTTP from ALB SG"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    source_security_group_id = "sg-0123456789abcdef0"
  }
]
```

Outputs:
- security_group_id
- security_group_arn
- security_group_name

