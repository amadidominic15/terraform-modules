resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + local.azs_count)
    count = local.azs_count
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.environment}-public-${local.azs[count.index]}"
        "kubernetes.io/cluster/${var.environment}" = "shared"
        "kubernetes.io/role/elb" = "1" 
    }
}