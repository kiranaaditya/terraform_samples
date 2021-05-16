#Create a VPC
resource "aws_vpc" "vpc-edureka" {
  provider             = aws.region-edureka
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(local.common_tags, {
    Name        = "vpc-edureka"
    Description = "Virtual private cloud for edureka sample"
    }
  )
}

# Create an elastic IP.
resource "aws_eip" "nat" {
  vpc      = true
  provider = aws.region-edureka
}

# Create NAT Gateway for private subnets
resource "aws_nat_gateway" "ngw-edureka" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet-edureka-jump.id
  provider      = aws.region-edureka
  tags = merge(local.common_tags, {
    Name        = "ngw-edureka"
    Description = "NAT gateway for edureka"
    }
  )
  depends_on = [aws_internet_gateway.igw-edureka]
}

#Create an Internet gateway for public subnets
resource "aws_internet_gateway" "igw-edureka" {
  provider = aws.region-edureka
  vpc_id   = aws_vpc.vpc-edureka.id
  tags = merge(local.common_tags, {
    Name        = "igw-edureka"
    Description = "Internet gateway for edureka sample"
    }
  )
}

#Create a custom route table for private subnet
resource "aws_route_table" "rtb-edureka-private" {
  provider = aws.region-edureka
  vpc_id   = aws_vpc.vpc-edureka.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-edureka.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = merge(local.common_tags, {
    Name        = "rtb-edureka-private"
    Description = "Route table for edureka sample"
    }
  )
  depends_on = [aws_instance.edureka-jump]
}

#Create a custom route table for public subnet
resource "aws_route_table" "rtb-edureka-public" {
  provider = aws.region-edureka
  vpc_id   = aws_vpc.vpc-edureka.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-edureka.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = merge(local.common_tags, {
    Name        = "rtb-edureka-public"
    Description = "Route table for edureka sample"
    }
  )
}

#Create a new route table of the VPC(edureka_Sample) for our private subnet
resource "aws_route_table_association" "rtb-edureka-master-slave" {
  provider       = aws.region-edureka
  subnet_id      = aws_subnet.subnet-edureka-master-slave.id
  route_table_id = aws_route_table.rtb-edureka-private.id
}

#Create a new route table of the VPC(edureka_Sample) for our public subnet
resource "aws_route_table_association" "rtb-edureka-jump" {
  provider       = aws.region-edureka
  subnet_id      = aws_subnet.subnet-edureka-jump.id
  route_table_id = aws_route_table.rtb-edureka-public.id
}

#Create a subnet for master and slave
resource "aws_subnet" "subnet-edureka-master-slave" {
  provider   = aws.region-edureka
  vpc_id     = aws_vpc.vpc-edureka.id
  cidr_block = "10.0.1.0/24"
  tags = merge(local.common_tags, {
    Name        = "subnet-edureka-master-slave"
    Description = "Subnet for edureka master slave"
    }
  )
}

#Create a subnet for jump server
resource "aws_subnet" "subnet-edureka-jump" {
  provider                = aws.region-edureka
  vpc_id                  = aws_vpc.vpc-edureka.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Name        = "subnet-edureka-jump"
    Description = "Subnet for edureka jump server"
  })
}