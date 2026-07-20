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

// Example: create Load Balancer SG and then create application SGs that reference it
module "lb_sg" {
  source      = "../modules/security_group"
  name        = var.lb_sg_name
  description = "Load Balancer Security Group"
  vpc_id      = var.vpc_id
  default_tags = var.default_tags
  tags = {
    Name = var.lb_sg_name
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

module "app_sg" {
  source      = "../modules/security_group"
  name        = var.app_sg_name
  description = "Fargate / Lambda Security Group"
  vpc_id      = var.vpc_id
  default_tags = var.default_tags
  tags = {
    Name = var.app_sg_name
  }
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
  source      = "../modules/security_group"
  name        = var.rds_sg_name
  description = "RDS Security Group"
  vpc_id      = var.vpc_id
  default_tags = var.default_tags
  tags = {
    Name = var.rds_sg_name
  }
  ingress_rules = [
    {
      description = "Postgres from app SG"
      protocol    = "tcp"
      from_port   = 5432
      to_port     = 5432
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
}
