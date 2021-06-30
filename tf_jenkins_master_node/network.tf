#Create a VPC
resource "aws_vpc" "vpc-jenkins" {
  provider             = aws.region-jenkins
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}-${data.terraform_remote_state.backend_resources.outputs.project_name}-${data.terraform_remote_state.backend_resources.outputs.env_name}-vpc"
    Description = "VPC for jenkins env"
    Role        = "Network"
    }
  )
}

#Create an Internet gateway for public subnets
resource "aws_internet_gateway" "igw-jenkins" {
  provider = aws.region-jenkins
  vpc_id   = aws_vpc.vpc-jenkins.id
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}-${data.terraform_remote_state.backend_resources.outputs.project_name}-${data.terraform_remote_state.backend_resources.outputs.env_name}-igw"
    Description = "IGW for jenkins env"
    Role        = "Network"
    }
  )
}

#Create a custom route table for public subnet
resource "aws_route_table" "rtb-jenkins-public" {
  provider = aws.region-jenkins
  vpc_id   = aws_vpc.vpc-jenkins.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-jenkins.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}-${data.terraform_remote_state.backend_resources.outputs.project_name}-${data.terraform_remote_state.backend_resources.outputs.env_name}-rtb"
    Description = "RTB for jenkins env"
    Role        = "Network"
    }
  )
}

#Create a new route table of the VPC(jenkins_Sample) for our private subnet
resource "aws_route_table_association" "rtb-jenkins-master-slave" {
  provider       = aws.region-jenkins
  subnet_id      = aws_subnet.subnet-jenkins-master-slave.id
  route_table_id = aws_route_table.rtb-jenkins-public.id
  depends_on     = [aws_subnet.subnet-jenkins-master-slave]
}

#Create a subnet for master and slave
resource "aws_subnet" "subnet-jenkins-master-slave" {
  provider                = aws.region-jenkins
  vpc_id                  = aws_vpc.vpc-jenkins.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}-${data.terraform_remote_state.backend_resources.outputs.project_name}-${data.terraform_remote_state.backend_resources.outputs.env_name}-subnet"
    Description = "Subnet for jenkins env"
    Role        = "Network"
    }
  )
}
