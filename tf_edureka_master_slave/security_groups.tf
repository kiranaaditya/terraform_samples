#Create SG for allowing all ports within the subnet for Master nodes.
resource "aws_security_group" "sg-master-node-edureka" {
  provider    = aws.region-edureka
  name        = "edureka-master-node"
  description = "Access is restricted with NACL"
  vpc_id      = aws_vpc.vpc-edureka.id
  ingress {
    description = "Allow all ports within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name        = "sg-master-edureka"
    description = "Security group for master in the edureka sample"
    }
  )
}

/* #Create SG for allowing all ports within the subnet for Slave nodes.
resource "aws_security_group" "sg-slave-edureka" {
  provider    = aws.region-edureka
  name        = "slave-sg"
  description = "Allow all ports within the subnet for now"
  vpc_id      = aws_vpc.vpc-edureka.id
  ingress {
    description = "Full access within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name        = "sg-slave-edureka"
    description = "Security group for slave in the edureka sample"
    }
  )
} */

/* #Create a SG for jump server
resource "aws_security_group" "sg-jump-edureka" {
  provider    = aws.region-edureka
  name        = "jump-sg"
  description = "Allow port 80 for yum for public but 22 only for me"
  vpc_id      = aws_vpc.vpc-edureka.id
  ingress {
    description = "Allow port 22 only from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/%s", data.external.whatsmyip.result["internet_ip"], 32)]
  }
  ingress {
    description = "Allow port 80 in public"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Full access within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name        = "sg-jump-edureka"
    description = "Security group for slave in the edureka sample"
    }
  )
} */
