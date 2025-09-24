resource "aws_eip" "nat" {
  count = var.create_nat_gateway ? 1 : 0
  
  tags  = merge({
    Name = "nat-eip"
  }, var.tags)
}
