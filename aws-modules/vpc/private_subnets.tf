resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index)
    count = local.azs_count
    availability_zone = local.azs[count.index]
    tags = {
         Name = "${var.environment}-private-${local.azs[count.index]}"
        "kubernetes.io/cluster/${var.environment}" = "shared"
        "kubernetes.io/role/internal-elb" = "1" 
    }
}