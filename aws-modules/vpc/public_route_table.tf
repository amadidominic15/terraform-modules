resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    tags = {
         Name = "${var.environment}-public-rt" 
    }
}

resource "aws_route" "public_internet" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
    count = local.azs_count
}