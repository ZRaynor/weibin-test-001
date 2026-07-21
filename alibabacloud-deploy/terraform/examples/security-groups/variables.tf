variable "aws_region" {
  type    = string
  default = "cn-north-1"
}

variable "vpc_id" {
  type = string
}

variable "lb_sg_name" {
  type    = string
  default = "lly-nw-com-imeeting-alb-q-sg-01"
}

variable "app_sg_name" {
  type    = string
  default = "lly-nw-com-imeeting-lambda-q-sg-01"
}

variable "ecs_sg_name" {
  type    = string
  default = "lly-nw-com-imeeting-ecs-q-sg-01"
}

variable "rds_sg_name" {
  type    = string
  default = "lly-nw-com-imeeting-rds-q-sg-01"
}

variable "redis_sg_name" {
  type    = string
  default = "lly-nw-com-imeeting-redis-q-sg-01"
}

variable "glue_sg_name" {
  type    = string
  default = "lly-nw-com-imeeting-glue-q-sg-01"
}

variable "ApplName" {
  type    = string
  default = "iMeeting - China meeting risk management system"
}

variable "AdminTeam" {
  type    = string
  default = "GISS"
}

variable "ApplicationCi" {
  type    = string
  default = "CI00000088669527"
}

variable "PrimaryItContact" {
  type    = string
  default = "cn_it_infra_cloud_ops@lists.lilly.com"
}

variable "SNOWRequestId" {
  type    = string
  default = ""
}

variable "SystemOwner" {
  type    = string
  default = "wang_li_jun_olivia@lilly.com"
}

variable "SystemCustodian" {
  type    = string
  default = "liu_yi16@lilly.com"
}

variable "CostCenter" {
  type    = string
  default = "5205061"
}

variable "MLPS" {
  type    = string
  default = "No"
}

variable "Environment" {
  type    = string
  default = "QA"
}

variable "BusinessArea" {
  type    = string
  default = "Commercial"
}

variable "Level1BusinessArea" {
  type    = string
  default = "IBU"
}
