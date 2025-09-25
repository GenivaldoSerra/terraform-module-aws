resource "aws_lb_target_group" "this" {
  for_each = local.target_groups_map

  name               = "${local.name}-${each.key}"
  port               = each.value.port
  protocol           = each.value.protocol
  protocol_version   = each.value.protocol_version
  vpc_id             = var.vpc_id
  target_type        = each.value.target_type
  
  deregistration_delay = each.value.deregistration_delay
  slow_start          = each.value.slow_start
  proxy_protocol_v2   = each.value.proxy_protocol_v2
  preserve_client_ip  = each.value.preserve_client_ip

  dynamic "stickiness" {
    for_each = each.value.stickiness != null ? [each.value.stickiness] : []
    content {
      type            = stickiness.value.type
      cookie_name     = stickiness.value.cookie_name
      cookie_duration = stickiness.value.cookie_duration
      enabled         = stickiness.value.enabled
    }
  }

  # Configuração de health check
  health_check {
    enabled             = each.value.health_check.enabled
    interval            = each.value.health_check.interval
    path                = each.value.health_check.path
    port                = each.value.health_check.port
    protocol            = each.value.health_check.protocol
    timeout             = each.value.health_check.timeout
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
    matcher             = each.value.health_check.matcher
  }

  tags = merge(
    local.common_tags,
    each.value.tags,
    {
      Name = "${local.name}-${each.key}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Attachment de targets aos target groups
resource "aws_lb_target_group_attachment" "this" {
  for_each = {
    for target in flatten([
      for tg_key, tg in var.target_groups : [
        for target in tg.targets : {
          key = "${tg_key}-${target.target_id}"
          target_group_name = tg_key
          target_id = target.target_id
          port = target.port
          availability_zone = target.availability_zone
        }
      ]
    ]) : target.key => target
  }

  target_group_arn = aws_lb_target_group.this[each.value.target_group_name].arn
  target_id        = each.value.target_id
  port             = each.value.port
  availability_zone = each.value.availability_zone
}