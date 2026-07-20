// Terraform module: security_group
// Creates an AWS Security Group and optional ingress/egress rules

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  // Default egress: allow all if no explicit egress rules provided
  dynamic "egress" {
    for_each = length(var.egress_rules) > 0 ? var.egress_rules : [{
      description     = "Allow all outbound"
      protocol        = "-1"
      from_port       = 0
      to_port         = 0
      cidr_blocks     = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      self            = false
      source_security_group_id = null
    }]
    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      self             = lookup(egress.value, "self", null)
    }
  }

  tags = merge(var.default_tags, var.tags)
}

// Create ingress rules. We use aws_security_group_rule to support source_security_group_id references.
resource "aws_security_group_rule" "ingress" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  security_group_id        = aws_security_group.this.id
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  description              = lookup(each.value, "description", null)

  // If a source_security_group_id is provided, set it
  source_security_group_id = lookup(each.value, "source_security_group_id", null)

  // only one of cidr_blocks vs source_security_group_id will be effective
}

resource "aws_security_group_rule" "self_ingress" {
  for_each = { for idx, s in var.self_ingress_rules : idx => s }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.this.id
  self              = true
  description       = lookup(each.value, "description", null)
}
