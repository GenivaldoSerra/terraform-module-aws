resource "aws_launch_template" "this" {
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = merge(var.tags, {
    "Name" = var.resource_name
  })
}