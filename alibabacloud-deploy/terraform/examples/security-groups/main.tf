terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

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

locals {
  common_tags = module.sg_parameters.default_tags
  names = module.sg_parameters.security_group_names
}

module "lb_sg" {
  source      = "../../modules/security_group"
  name        = local.names.lb
  description = "Load Balancer Security Group"
  vpc_id      = module.sg_parameters.vpc_id

  default_tags    = local.common_tags
  additional_tags = { Name = local.names.lb }

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

module "app_sg" {
  source      = "../../modules/security_group"
  name        = local.names.app
  description = "Fargate and Lambda Security Group"
  vpc_id      = module.sg_parameters.vpc_id

  default_tags    = local.common_tags
  additional_tags = { Name = local.names.app }

  ingress_rules = [
    {
      description = "HTTP from Load Balancer"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      source_security_group_id = module.lb_sg.security_group_id
    }
  ]
}

module "ecs_sg" {
  source      = "../../modules/security_group"
  name        = local.names.ecs
  description = "ECS Security Group"
  vpc_id      = module.sg_parameters.vpc_id

  default_tags    = local.common_tags
  additional_tags = { Name = local.names.ecs }

  ingress_rules = [
    {
      description = "HTTP from Load Balancer"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      source_security_group_id = module.lb_sg.security_group_id
    }
  ]
}

module "rds_sg" {
  source      = "../../modules/security_group"
  name        = local.names.rds
  description = "RDS Security Group"
  vpc_id      = module.sg_parameters.vpc_id

  default_tags    = local.common_tags
  additional_tags = { Name = local.names.rds }

  ingress_rules = [
    {
      description = "Postgres from App Security Group"
      protocol    = "tcp"
      from_port   = 5432
      to_port     = 5432
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
}

module "redis_sg" {
  source      = "../../modules/security_group"
  name        = local.names.redis
  description = "Redis Security Group"
  vpc_id      = module.sg_parameters.vpc_id

  default_tags    = local.common_tags
  additional_tags = { Name = local.names.redis }

  ingress_rules = [
    {
      description = "Redis from App Security Group"
      protocol    = "tcp"
      from_port   = 6379
      to_port     = 6379
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
}

module "glue_sg" {
  source      = "../../modules/security_group"
  name        = local.names.glue
  description = "Glue Security Group"
  vpc_id      = module.sg_parameters.vpc_id

  default_tags    = local.common_tags
  additional_tags = { Name = local.names.glue }

  self_ingress_rules = [
    {
      description = "Allow all traffic within Glue security group"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
    }
  ]
}
