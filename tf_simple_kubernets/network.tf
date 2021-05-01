#Create a VPC
resource "aws_vpc" "vpc-k8s-sample" {
  provider             = aws.region-k8s-sample
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name        = "vpc-k8s-sample"
    Description = "Virtual private cloud for K8s sample"
    }
  )
}

#Create an Internet gateway for the VPC
resource "aws_internet_gateway" "igw-k8s-sample" {
  provider = aws.region-k8s-sample
  vpc_id   = aws_vpc.vpc-k8s-sample.id

  tags = merge(local.common_tags, {
    Name        = "igw-k8s-sample"
    Description = "Internet gateway for K8s sample"
    }
  )
}

#Create a custom route table for our purposes
resource "aws_route_table" "rtb-k8s-sample" {
  provider = aws.region-k8s-sample
  vpc_id   = aws_vpc.vpc-k8s-sample.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-k8s-sample.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = merge(local.common_tags, {
    Name        = "rtb-k8s-sample"
    Description = "Route table for K8s sample"
    }
  )
}

#Overwrite the default route table of the VPC(K8S_Sample) with our route table entries
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.region-k8s-sample
  vpc_id         = aws_vpc.vpc-k8s-sample.id
  route_table_id = aws_route_table.rtb-k8s-sample.id
}

#Create a subnet 
resource "aws_subnet" "subnet-k8s-sample" {
  provider   = aws.region-k8s-sample
  vpc_id     = aws_vpc.vpc-k8s-sample.id
  cidr_block = "10.0.1.0/24"
  tags = merge(local.common_tags, {
    Name        = "subnet-k8s-sample"
    Description = "Subnet for K8s sample"
    }
  )
}