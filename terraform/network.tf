# Create VPC
resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MegamixVPC"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.az
  tags = {
    Name = "MegamixPublicSubnet"
  }
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.az
  tags = {
    Name = "MegamixPrivateSubnet"
  }
}

# Create Public IP
resource "aws_eip" "public_ip" {
  domain = "vpc"
  tags = {
    Name = "MegamixPublicIP"
  }
}

# Create Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MegamixInternetGateway"
  }
}

# Create NAT GW
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.public_ip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "MegamixNATGateway"
  }
}

# Create public routing table
resource "aws_route_table" "public_routing_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MegamixPublicRouteTable"
  }
}

# Create private routing table
resource "aws_route_table" "private_routing_table" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MegamixPrivateRouteTable"
  }
}

# Attach public subnet to IGW
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_routing_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Attach private subnet to NATGW
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private_routing_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.id
}

# Associate routing to public subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_routing_table.id
}

# Associate routing to private subnet
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_routing_table.id
}


# Security group for db
resource "aws_security_group" "sg-db" {
  name   = "sg_db"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


