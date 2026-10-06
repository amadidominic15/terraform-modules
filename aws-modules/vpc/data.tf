data "aws_availability_zones" "azs" {
    state = "available"
}
data "aws_region" "current" {}

locals {
    azs_count = min(var.azs_count, length(data.aws_availability_zones.azs.names))
    azs = slice(data.aws_availability_zones.azs.names, 0, local.azs_count)
}
