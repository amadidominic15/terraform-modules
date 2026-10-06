resource "aws_eip" "nat" {
    domain = "vpc"
    count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : local.azs_count) : 0
    depends_on = [aws_internet_gateway.main]
    tags = {
         Name = "${var.environment}-nat-eip-${count.index + 1 }" 
    }     
}