#Create a VPC
resource "aws_vpc" "vpc-kiran" {
  provider             = aws.region-kiran
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(local.common_tags, {
    Name        = "$${var.author_name}-${var.project_name}-${var.env_name}-vpc"
    Description = "VPC for kiran"
    Role        = "Network"
    }
  )
}

#Create an Internet gateway for public subnets
resource "aws_internet_gateway" "igw-kiran" {
  provider = aws.region-kiran
  vpc_id   = aws_vpc.vpc-kiran.id
  tags = merge(local.common_tags, {
    Name        = "${var.author_name}-${var.project_name}-${var.env_name}-igw"
    Description = "IGW for kiran"
    Role        = "Network"
    }
  )
}

#Create a custom route table for public subnet
resource "aws_route_table" "rtb-kiran" {
  provider = aws.region-kiran
  vpc_id   = aws_vpc.vpc-kiran.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-kiran.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = merge(local.common_tags, {
    Name        = "${var.author_name}-${var.project_name}-${var.env_name}-rtb"
    Description = "RTB for kiran"
    Role        = "Network"
    }
  )
}

#Create a new route table of the VPC(jenkins_Sample) for our private subnet
resource "aws_route_table_association" "rtb-kiran" {
  provider       = aws.region-kiran
  subnet_id      = aws_subnet.subnet-kiran.id
  route_table_id = aws_route_table.rtb-kiran.id
  depends_on     = [aws_subnet.subnet-kiran]
}

#Create a subnet for master and slave
resource "aws_subnet" "subnet-kiran" {
  provider                = aws.region-kiran
  vpc_id                  = aws_vpc.vpc-kiran.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Name        = "${var.author_name}-${var.project_name}-${var.env_name}-subnet"
    Description = "Subnet for kiran"
    Role        = "Network"
    }
  )
}
