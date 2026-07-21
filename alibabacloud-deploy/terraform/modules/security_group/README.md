# Terraform Module: security_group

This module creates a single AWS Security Group and supports a list of ingress rules, self-referential ingress, and optional custom tags.

## Features

- Uses a reusable module for each Security Group
- Accepts a list of ingress rules so policy differences are driven by data, not duplicate resource blocks
- Supports both `cidr_blocks` and `source_security_group_id`
- Supports `self_ingress_rules` for traffic allowed within the same security group
- Merges common default tags with per-group additional tags

## Inputs

- `name`: Security group name
- `description`: Description
- `vpc_id`: VPC identifier
- `default_tags`: Common tag map for all security groups
- `additional_tags`: Extra tags for a specific security group
- `ingress_rules`: List of ingress rule objects
- `self_ingress_rules`: List of self ingress rule objects
- `egress_rules`: Optional egress rules; defaults to allow all outbound

## Example

```hcl
module "lb_sg" {
  source      = "../../modules/security_group"
  name        = "lly-nw-com-imeeting-alb-q-sg-01"
  description = "Load Balancer Security Group"
  vpc_id      = var.vpc_id

  default_tags = module.sg_parameters.default_tags
  additional_tags = {
    Name = "lly-nw-com-imeeting-alb-q-sg-01"
  }

  ingress_rules = [
    {
      description = "HTTPS from anywhere"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
```

This module is intended to be combined with a parameter module such as `sg_parameters` to separate the environment-specific name/tag configuration from the policy-specific ingress rules.
