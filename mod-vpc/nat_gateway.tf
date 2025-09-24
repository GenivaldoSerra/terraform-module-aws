resource "aws_nat_gateway" "this" {
	count         = var.create_nat_gateway ? 1 : 0
	allocation_id = aws_eip.nat[0].id
	subnet_id     = length(aws_subnet.public) > 0 ? aws_subnet.public[0].id : null
	
  tags          = merge({
		Name = "nat-gateway"
	}, var.tags)
}