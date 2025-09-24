output "autoscaling_group_id" {
  description = "ID do Auto Scaling Group"
  value       = aws_autoscaling_group.this.id
}

output "autoscaling_group_name" {
  description = "Nome do Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "autoscaling_group_arn" {
  description = "ARN do Auto Scaling Group"
  value       = aws_autoscaling_group.this.arn
}