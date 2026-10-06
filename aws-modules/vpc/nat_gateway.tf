resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = var.single_nat_gateway ? aws_subnet.public[0].id : aws_subnet.public[count.index].id
    count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.azs_count) : 0
    depends_on = [ aws_internet_gateway.main ]
    tags = {
        Name = "${var.environment}-nat-${count.index + 1}" 
    }   
}