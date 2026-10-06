resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    count = local.azs_count
    tags = {
         Name = "${var.environment}-private-rt-${local.azs[count.index]}" 
    }
}

resource "aws_route" "private_nat" {
    route_table_id = aws_route_table.private[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.single_nat_gateway ? aws_nat_gateway.main[0].id : aws_nat_gateway.main[count.index].id
    count = var.enable_nat_gateway ? local.azs_count : 0
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
    count = local.azs_count
}