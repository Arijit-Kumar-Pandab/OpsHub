resource "aws_internet_gateway" "opshub" {
  vpc_id = aws_vpc.opshub.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}