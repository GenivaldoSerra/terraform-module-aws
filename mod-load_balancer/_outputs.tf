# Application Load Balancer
output "lb" {
  description = "Todos os atributos do Load Balancer"
  value = {
    id         = aws_lb.this.id
    arn        = aws_lb.this.arn
    name       = aws_lb.this.name
    dns_name   = aws_lb.this.dns_name
    zone_id    = aws_lb.this.zone_id
    type       = aws_lb.this.load_balancer_type
    internal   = aws_lb.this.internal
    subnet_ids = aws_lb.this.subnets
    security_groups = aws_lb.this.security_groups
  }
}

# Target Groups
output "target_groups" {
  description = "Detalhes de todos os target groups criados"
  value = {
    for key, tg in aws_lb_target_group.this : key => {
      id   = tg.id
      arn  = tg.arn
      name = tg.name
      port = tg.port
      protocol = tg.protocol
      vpc_id = tg.vpc_id
      target_type = tg.target_type
      health_check = tg.health_check
      tags = tg.tags
    }
  }
}

# Listeners
output "listeners" {
  description = "Detalhes de todos os listeners criados"
  value = {
    for key, listener in aws_lb_listener.this : key => {
      id      = listener.id
      arn     = listener.arn
      port    = listener.port
      protocol = listener.protocol
      ssl_policy = listener.ssl_policy
      certificate_arn = listener.certificate_arn
      default_action = listener.default_action
      tags = listener.tags
    }
  }
}

# Target Group Attachments
output "target_group_attachments" {
  description = "Detalhes de todas as instâncias/targets registrados"
  value = {
    for key, attachment in aws_lb_target_group_attachment.this : key => {
      target_group_arn = attachment.target_group_arn
      target_id = attachment.target_id
      port = attachment.port
      availability_zone = attachment.availability_zone
    }
  }
}

# Helper Outputs
output "dns_name" {
  description = "DNS name do load balancer"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "Route53 zone ID do load balancer"
  value       = aws_lb.this.zone_id
}

output "target_groups_map" {
  description = "Mapa de nome do target group para ARN, útil para referências em listener rules"
  value = {
    for key, tg in aws_lb_target_group.this : key => tg.arn
  }
}