# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "seal-vpc"
    Project = "Seal"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "seal-main-gateway"
    Project = "Seal"
  }
}

# Public Subnets
resource "aws_subnet" "public_sub_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet-1"
    Project = "Seal"
  }
}

resource "aws_subnet" "public_sub_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
    Project = "Seal"
  }
}

# Private Subnets
resource "aws_subnet" "private_sub_1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
    Project = "Seal"
  }
}

resource "aws_subnet" "private_sub_2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
    Project = "Seal"
  }
}

# NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_sub_1.id

  tags = {
    Name = "seal-nat-gateway"
    Project = "Seal"
  }
}

# Route Tables
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
    Project = "Seal"
  }
}

resource "aws_route_table" "private_rtb_1" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-route-table"
    Project = "Seal"
  }
}

resource "aws_route_table" "private_rtb_2" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-route-table"
    Project = "Seal"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_sub_1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_sub_2.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_sub_1.id
  route_table_id = aws_route_table.private_rtb_1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_sub_2.id
  route_table_id = aws_route_table.private_rtb_2.id
}
