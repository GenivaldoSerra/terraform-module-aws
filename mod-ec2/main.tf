resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
    instance_metadata_tags      = var.metadata_instance_tags
  }

  tags = merge({
    Name = "${var.name_prefix}-ec2"
  }, var.tags)
}
