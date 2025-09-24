resource "aws_internet_gateway" "this" {
	vpc_id = aws_vpc.this.id
	
  tags   = merge({
		Name = "internet-gateway"
	}, var.tags)
}
