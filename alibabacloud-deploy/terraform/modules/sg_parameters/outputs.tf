output "vpc_id" {
  description = "VPC ID for the target network"
  value       = var.vpc_id
}

output "security_group_names" {
  description = "Named security groups used by the environment"
  value = {
    lb    = var.lb_security_group_name
    app   = var.app_security_group_name
    ecs   = var.ecs_security_group_name
    rds   = var.rds_security_group_name
    redis = var.redis_security_group_name
    glue  = var.glue_security_group_name
  }
}

output "default_tags" {
  description = "Common tags to apply to all security groups"
  value       = var.tag_values
}
