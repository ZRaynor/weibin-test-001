# Terraform Module: sg_parameters

This module centralizes the base parameters required to create security groups in the same style as your CloudFormation template.

It encapsulates:

- VPC ID
- Security group name tags for ALB, application, ECS, RDS, Redis, Glue
- Common metadata tags such as `ApplName`, `AdminTeam`, `ApplicationCi`, `PrimaryItContact`, `SystemOwner`, `SystemCustodian`, `CostCenter`, `Environment`, `BusinessArea`, and `Level1BusinessArea`

## Usage

```hcl
module "sg_parameters" {
  source = "../../modules/sg_parameters"

  vpc_id = var.vpc_id

  lb_security_group_name    = var.lb_sg_name
  app_security_group_name   = var.app_sg_name
  ecs_security_group_name   = var.ecs_sg_name
  rds_security_group_name   = var.rds_sg_name
  redis_security_group_name = var.redis_sg_name
  glue_security_group_name  = var.glue_sg_name

  tag_values = {
    ApplName           = var.ApplName
    AdminTeam          = var.AdminTeam
    ApplicationCi      = var.ApplicationCi
    PrimaryItContact   = var.PrimaryItContact
    SNOWRequestId      = var.SNOWRequestId
    SystemOwner        = var.SystemOwner
    SystemCustodian    = var.SystemCustodian
    CostCenter         = var.CostCenter
    MLPS               = var.MLPS
    Environment        = var.Environment
    BusinessArea       = var.BusinessArea
    Level1BusinessArea = var.Level1BusinessArea
  }
}
```
