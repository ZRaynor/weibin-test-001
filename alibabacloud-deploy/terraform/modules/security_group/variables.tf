variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description for the security group"
  type        = string
  default     = "Managed by Terraform security_group module"
}

variable "vpc_id" {
  description = "VPC id where the security group will be created"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the security group"
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "Default tags merged with `tags`. Use to pass applName/admin etc"
  type        = map(string)
  default     = {}
}

variable "ingress_rules" {
  description = <<EOF
List of ingress rule objects. Each object supports fields:
- description (optional)
- protocol (string, e.g. "tcp" or "-1")
- from_port (number)
- to_port (number)
- cidr_blocks (optional list(string))
- ipv6_cidr_blocks (optional list(string))
- prefix_list_ids (optional list(string))
- source_security_group_id (optional string) - use this to reference another SG
EOF
  type = list(object({
    description               = optional(string)
    protocol                  = string
    from_port                 = number
    to_port                   = number
    cidr_blocks               = optional(list(string))
    ipv6_cidr_blocks          = optional(list(string))
    prefix_list_ids           = optional(list(string))
    source_security_group_id  = optional(string)
  }))
  default = []
}

variable "self_ingress_rules" {
  description = "List of ingress rules where source is self (allowing traffic inside the same SG)"
  type = list(object({
    description = optional(string)
    protocol    = string
    from_port   = number
    to_port     = number
  }))
  default = []
}

variable "egress_rules" {
  description = "Optional egress rules. If empty module creates a default allow-all egress rule. Same object shape as ingress rules"
  type = list(object({
    description = optional(string)
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_blocks = optional(list(string))
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    self = optional(bool)
  }))
  default = []
}
