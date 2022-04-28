
data "aws_availability_zones" "available" {
  state = "available"
}

# Main  vpc
resource "aws_vpc" "project_vpc" {
  cidr_block       = var.project_VPC_CIDR_BLOC
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc"
  }
}

# Public subnets

#public WEB Subnet 1
resource "aws_subnet" "project_vpc_public_subnet_1" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.project_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-project-vpc-public-subnet-1"
  }
}

#public WEB Subnet 2
resource "aws_subnet" "project_vpc_public_subnet_2" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.project_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-project-vpc-public-subnet-2"
  }
}

# private APP subnet 1
resource "aws_subnet" "project_vpc_private_APP_subnet_1" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.project_VPC_PRIVATE_APP_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.ENVIRONMENT}-project-vpc-private-APP-subnet-1"
  }
}
# private APP subnet 2
resource "aws_subnet" "project_vpc_private_APP_subnet_2" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.project_VPC_PRIVATE_APP_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.ENVIRONMENT}-project-vpc-private-APP-subnet-2"
  }
}

# private DB subnet 1
resource "aws_subnet" "project_vpc_private_DB_subnet_1" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.project_VPC_PRIVATE_DB_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.ENVIRONMENT}-project-vpc-private-DB-subnet-1"
  }
}

# private DB subnet 2
resource "aws_subnet" "project_vpc_private_DB_subnet_2" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = var.project_VPC_PRIVATE_DB_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.ENVIRONMENT}-project-vpc-private-DB-subnet-2"
  }
}

# internet gateway
resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "${var.ENVIRONMENT}-project-vpc-internet-gateway"
  }
}

# ELastic IP for NAT Gateway
resource "aws_eip" "project_nat_eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.project_igw]
}

# NAT gateway for private ip address
resource "aws_nat_gateway" "project_ngw" {
  allocation_id = aws_eip.project_nat_eip.id
  subnet_id     = aws_subnet.project_vpc_public_subnet_1.id
  depends_on = [aws_internet_gateway.project_igw]
  tags = {
    Name = "${var.ENVIRONMENT}-project-vpc-NAT-gateway"
  }
}

# Route Table for public Architecture
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-project-public-route-table"
  }
}

# Route table for Private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.project_ngw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-project-private-route-table"
  }
}

# Route Table association with WEB public subnets
resource "aws_route_table_association" "to_public_subnet1" {
  subnet_id      = aws_subnet.project_vpc_public_subnet_1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "to_public_subnet2" {
  subnet_id      = aws_subnet.project_vpc_public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# Route table association with APP private subnets
resource "aws_route_table_association" "to_private_APP_subnet1" {
  subnet_id      = aws_subnet.project_vpc_private_APP_subnet_1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "to_private_APP_subnet2" {
  subnet_id      = aws_subnet.project_vpc_private_APP_subnet_2.id
  route_table_id = aws_route_table.private.id
}

# Route table association with DB private subnets
resource "aws_route_table_association" "to_private_DB_subnet1" {
  subnet_id      = aws_subnet.project_vpc_private_DB_subnet_1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "to_private_DB_subnet2" {
  subnet_id      = aws_subnet.project_vpc_private_DB_subnet_2.id
  route_table_id = aws_route_table.private.id
}

provider "aws" {
  region     = var.AWS_REGION
}

#Output Specific to Custom VPC
output "my_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.project_vpc.id
}

output "private_APP_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.project_vpc_private_APP_subnet_1.id
}

output "private_APP_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.project_vpc_private_APP_subnet_2.id
}

output "private_DB_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.project_vpc_private_DB_subnet_1.id
}

output "private_DB_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.project_vpc_private_DB_subnet_2.id
}

output "public_web_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.project_vpc_public_subnet_1.id
}

output "public_web_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.project_vpc_public_subnet_2.id
}

#DB CIDR Block
output "private_db_cidr_subnet1" {
  description = "Subnet1 CIDR"
  value       = aws_subnet.project_vpc_private_DB_subnet_1.cidr_block
}

output "private_db_cidr_subnet2" {
  description = "Subnet2 CIDR"
  value       = aws_subnet.project_vpc_private_DB_subnet_2.cidr_block
}