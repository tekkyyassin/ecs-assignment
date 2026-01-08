locals {
  base_tags = merge(var.tags, {
    Project = var.project_name
  })
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.base_tags, {
    Name = "${var.project_name}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.base_tags, {
    Name = "${var.project_name}-igw"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.base_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

resource "aws_route" "public_rt_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs) #consider for_each
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.base_tags, {
    Name = "${var.project_name}-public-${var.azs[count.index]}"
  })
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.private_subnets_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.base_tags, {
    Name = "${var.project_name}-private-${var.azs[count.index]}"
  })
}

resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eips" {
  count  = length(var.azs)
  domain = "vpc"

  tags = merge(local.base_tags, {
    Name = "${var.project_name}-nat-eip-${var.azs[count.index]}"
  })
}

resource "aws_nat_gateway" "nat_gateways" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = merge(local.base_tags, {
    Name = "${var.project_name}-nat-${var.azs[count.index]}"
  })
}

resource "aws_route_table" "private_rts" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  tags = merge(local.base_tags, {
    Name = "${var.project_name}-private-rt-${var.azs[count.index]}"
  })
}

# default route for each private RT -> matching NAT GW (same AZ index)
resource "aws_route" "private_rt_nat_access" {
  count                  = length(var.azs)
  route_table_id         = aws_route_table.private_rts[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateways[count.index].id
}

# associate each private subnet -> matching private route table (same AZ index)
resource "aws_route_table_association" "private_subnet_associations" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rts[count.index].id
}
