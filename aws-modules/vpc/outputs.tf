output "vpc_id" {
    value = aws_vpc.main.id
}
output "vpc_cidr" {
    value = aws_vpc.main.cidr_block
}
output "availability_zones" {
    value = local.azs
}
output "private_subnets_ids" {
    value = aws_subnet.private[*].id
}
output "public_subnets_ids" {
    value = aws_subnet.public[*].id
}
output "private_subnets_cidrs" {
    value = aws_subnet.private[*].cidr_block
}
output "public_subnets_cidrs" {
    value = aws_subnet.public[*].cidr_block
}
output "nat_gateway_id" {
    value = aws_nat_gateway.main[*].id
}