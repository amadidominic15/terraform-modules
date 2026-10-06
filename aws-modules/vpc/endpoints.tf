resource "aws_vpc_endpoint" "s3" {
    vpc_id            = aws_vpc.main.id
    service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
    vpc_endpoint_type = "Gateway"
    route_table_ids = aws_route_table.private[*].id
    count = var.enable_vpc_endpoints ? 1 : 0
    tags = {
        Name = "${var.environment}-s3-endpoint"
    }
}

