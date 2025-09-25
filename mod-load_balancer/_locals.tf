locals {
  # Tags comuns para todos os recursos
  common_tags = merge(
    var.tags,
    {
      "Terraform"   = "true"
      "Module"      = "alb"
      "Environment" = var.environment
    }
  )

  # Normalizacao do nome do load balancer
  name = lower(trim(var.name_prefix, "-"))

  # Mapa de protocols válidos por listener
  valid_protocols = {
    "HTTP"  = 80
    "HTTPS" = 443
  }

  # Políticas SSL recomendadas por tipo
  recommended_ssl_policies = {
    "default" = "ELBSecurityPolicy-2016-08"
    "TLS1.2"  = "ELBSecurityPolicy-TLS-1-2-2017-01"
    "FIPS"    = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  }

  # Validações de health check
  health_check_defaults = {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    matcher             = "200"
  }

  # Mapeamento de target groups para facilitar referência
  target_groups_map = {
    for tg in var.target_groups : tg.name => tg
  }
}