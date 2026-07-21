variable "vpc_id" {
  description = "VPC ID where all security groups will be created."
  type        = string
}

variable "lb_security_group_name" {
  description = "Load Balancer security group name"
  type        = string
  default     = "lly-nw-com-imeeting-alb-q-sg-01"
}

variable "app_security_group_name" {
  description = "Fargate and Lambda security group name"
  type        = string
  default     = "lly-nw-com-imeeting-lambda-q-sg-01"
}

variable "ecs_security_group_name" {
  description = "ECS security group name"
  type        = string
  default     = "lly-nw-com-imeeting-ecs-q-sg-01"
}

variable "rds_security_group_name" {
  description = "RDS security group name"
  type        = string
  default     = "lly-nw-com-imeeting-rds-q-sg-01"
}

variable "redis_security_group_name" {
  description = "Redis security group name"
  type        = string
  default     = "lly-nw-com-imeeting-redis-q-sg-01"
}

variable "glue_security_group_name" {
  description = "Glue security group name"
  type        = string
  default     = "lly-nw-com-imeeting-glue-q-sg-01"
}

variable "tag_values" {
  description = "Common tag values for all security groups"
  type = object({
    ApplName           = string
    AdminTeam          = string
    ApplicationCi      = string
    PrimaryItContact   = string
    SNOWRequestId      = string
    SystemOwner        = string
    SystemCustodian    = string
    CostCenter         = string
    MLPS               = string
    Environment        = string
    BusinessArea       = string
    Level1BusinessArea = string
  })
  default = {
    ApplName           = "iMeeting - China meeting risk management system"
    AdminTeam          = "GISS"
    ApplicationCi      = "CI00000088669527"
    PrimaryItContact   = "cn_it_infra_cloud_ops@lists.lilly.com"
    SNOWRequestId      = ""
    SystemOwner        = "wang_li_jun_olivia@lilly.com"
    SystemCustodian    = "liu_yi16@lilly.com"
    CostCenter         = "5205061"
    MLPS               = "No"
    Environment        = "QA"
    BusinessArea       = "Commercial"
    Level1BusinessArea = "IBU"
  }
}
