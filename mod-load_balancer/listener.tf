resource "aws_lb_listener" "this" {
  for_each = { for l in var.listeners : l.name => l }
  
  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = each.value.ssl_policy
  certificate_arn   = each.value.certificate_arn

  dynamic "default_action" {
    for_each = [each.value.default_action]
    content {
      type = default_action.value.type

      dynamic "forward" {
        for_each = default_action.value.type == "forward" ? [default_action.value.forward] : []
        content {
          dynamic "target_group" {
            for_each = forward.value.target_groups
            content {
              arn    = target_group.value.target_group_arn
              weight = target_group.value.weight
            }
          }

          dynamic "stickiness" {
            for_each = forward.value.stickiness != null ? [forward.value.stickiness] : []
            content {
              duration = stickiness.value.duration
              enabled  = stickiness.value.enabled
            }
          }
        }
      }

      dynamic "redirect" {
        for_each = default_action.value.type == "redirect" ? [default_action.value.redirect] : []
        content {
          port        = redirect.value.port
          protocol    = redirect.value.protocol
          host        = redirect.value.host
          path        = redirect.value.path
          query       = redirect.value.query
          status_code = redirect.value.status_code
        }
      }

      dynamic "fixed_response" {
        for_each = default_action.value.type == "fixed-response" ? [default_action.value.fixed_response] : []
        content {
          content_type = fixed_response.value.content_type
          message_body = fixed_response.value.message_body
          status_code  = fixed_response.value.status_code
        }
      }
    }
  }

  dynamic "rule" {
    for_each = each.value.rules != null ? each.value.rules : []
    content {
      priority = rule.value.priority

      dynamic "condition" {
        for_each = rule.value.conditions
        content {
          dynamic "host_header" {
            for_each = condition.value.type == "host-header" ? [condition.value] : []
            content {
              values = host_header.value.values
            }
          }

          dynamic "path_pattern" {
            for_each = condition.value.type == "path-pattern" ? [condition.value] : []
            content {
              values = path_pattern.value.values
            }
          }

          dynamic "source_ip" {
            for_each = condition.value.type == "source-ip" ? [condition.value] : []
            content {
              values = source_ip.value.values
            }
          }

          dynamic "http_header" {
            for_each = condition.value.type == "http-header" ? [condition.value] : []
            content {
              http_header_name = http_header.value.http_header_name
              values          = http_header.value.values
            }
          }

          dynamic "query_string" {
            for_each = condition.value.type == "query-string" ? [condition.value] : []
            content {
              values = [for v in query_string.value.values : {
                key   = split("=", v)[0]
                value = split("=", v)[1]
              }]
            }
          }
        }
      }

      dynamic "action" {
        for_each = [rule.value.action]
        content {
          type = action.value.type

          dynamic "forward" {
            for_each = action.value.type == "forward" ? [action.value.forward] : []
            content {
              dynamic "target_group" {
                for_each = forward.value.target_groups
                content {
                  arn    = target_group.value.target_group_arn
                  weight = target_group.value.weight
                }
              }

              dynamic "stickiness" {
                for_each = forward.value.stickiness != null ? [forward.value.stickiness] : []
                content {
                  duration = stickiness.value.duration
                  enabled  = stickiness.value.enabled
                }
              }
            }
          }

          dynamic "redirect" {
            for_each = action.value.type == "redirect" ? [action.value.redirect] : []
            content {
              port        = redirect.value.port
              protocol    = redirect.value.protocol
              host        = redirect.value.host
              path        = redirect.value.path
              query       = redirect.value.query
              status_code = redirect.value.status_code
            }
          }

          dynamic "fixed_response" {
            for_each = action.value.type == "fixed-response" ? [action.value.fixed_response] : []
            content {
              content_type = fixed_response.value.content_type
              message_body = fixed_response.value.message_body
              status_code  = fixed_response.value.status_code
            }
          }
        }
      }
    }
  }

  tags = merge({
    Name = "${var.name_prefix}-listener-${each.value.name}"
  }, var.tags)
}