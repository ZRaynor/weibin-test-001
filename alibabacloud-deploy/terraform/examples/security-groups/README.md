# Security Group Deployment Example

This example demonstrates how to split your CloudFormation-inspired security group deployment into two Terraform modules:

1. `sg_parameters` - Defines the base deployment parameters and common tags.
2. `security_group` - Creates each security group and policies from reusable ingress rule data.

## How it works

- `sg_parameters` centralizes VPC settings, Security Group names, and tag values.
- Each `security_group` module instance receives a nametag and a list of `ingress_rules`.
- The Security Group policy is data-driven, so the only differences between groups are the rule objects.

## Run this example

```bash
cd alibabacloud-deploy/terraform/examples/security-groups
terraform init
terraform plan -var-file=terraform.tfvars.example
```

## What is modeled

- ALB Security Group with HTTPS ingress from 0.0.0.0/0
- App Security Group allowing HTTP from ALB
- ECS Security Group allowing HTTP from ALB
- RDS Security Group allowing Postgres from App SG
- Redis Security Group allowing Redis from App SG
- Glue Security Group allowing self-referenced traffic within the Glue group

## Customize

Update `terraform.tfvars.example` with your own `vpc_id`, AWS region, and any name overrides.
