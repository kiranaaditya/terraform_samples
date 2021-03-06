#Create SG for allowing all ports within the subnet for Master nodes.
resource "aws_security_group" "sg-kiran" {
  provider    = aws.region-kiran
  name        = "kiran-sg"
  description = "Access is restricted with NACL"
  vpc_id      = aws_vpc.vpc-kiran.id
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
    Name        = "${var.author_name}-${var.project_name}-${var.env_name}-sg"
    Description = "Security group for kiran"
    Role        = "Security"
    }
  )
}

