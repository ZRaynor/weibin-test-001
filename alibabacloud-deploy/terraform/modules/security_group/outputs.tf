output "security_group_id" {
  description = "The id of the security group"
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "The arn of the security group"
  value       = aws_security_group.this.arn
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.this.name
}
