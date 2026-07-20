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

variable "rds_sg_name" {
  type    = string
  default = "lly-nw-com-imeeting-rds-q-sg-01"
}

variable "default_tags" {
  type = map(string)
  default = {
    ApplName = "iMeeting - China meeting risk management system"
    AdminTeam = "GISS"
    ApplicationCi = "CI00000088669527"
    PrimaryItContact = "cn_it_infra_cloud_ops@lists.lilly.com"
    SystemOwner = "wang_li_jun_olivia@lilly.com"
    SystemCustodian = "liu_yi16@lilly.com"
    CostCenter = "5205061"
    MLPS = "No"
    Environment = "QA"
    BusinessArea = "Commercial"
    Level1BusinessArea = "IBU"
  }
}
