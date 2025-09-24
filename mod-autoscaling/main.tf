resource "aws_autoscaling_group" "this" {
  name                      = var.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  availability_zones        = var.availability_zones
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }
}