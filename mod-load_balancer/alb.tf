resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  # Habilitar logs de acesso se configurado
  dynamic "access_logs" {
    for_each = var.enable_access_logs && var.access_logs_bucket != null ? [1] : []
    content {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = true
    }
  }

  tags = merge({
    Name = "${var.name_prefix}-alb"
  }, var.tags)
}