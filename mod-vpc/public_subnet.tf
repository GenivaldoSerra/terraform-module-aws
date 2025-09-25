resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.public_subnet_azs[count.index]

  tags = merge({
    Name = "public-subnet-${count.index}"
  }, var.tags)
}
