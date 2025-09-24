resource "aws_subnet" "private" {
	count             = length(var.private_subnet_cidrs)
	vpc_id            = aws_vpc.this.id
	cidr_block        = var.private_subnet_cidrs[count.index]
	availability_zone = var.private_subnet_azs[count.index]
	
  tags = merge({
		Name = "private-subnet-${count.index}"
	}, var.tags)
}
