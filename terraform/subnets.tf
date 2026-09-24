resource "aws_subnet" "public" {
  count = var.availability_zone_count

  vpc_id = aws_vpc.opshub.id

  cidr_block = cidrsubnet(
    var.vpc_cidr,
    4,
    count.index
  )

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-${count.index + 1}"
    Tier = "public"

    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private" {
  count = var.availability_zone_count

  vpc_id = aws_vpc.opshub.id

  cidr_block = cidrsubnet(
    var.vpc_cidr,
    4,
    count.index + var.availability_zone_count
  )

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${local.name_prefix}-private-${count.index + 1}"
    Tier = "private"

    "kubernetes.io/role/internal-elb" = "1"
  }
}