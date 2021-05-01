#Create an Security Group for master node ports allowed {22, 80} and all ports within the subnet.
resource "aws_security_group" "sg-master-k8s-sample" {
  provider    = aws.region-k8s-sample
  name        = "k8s-master"
  description = "Allow port 22 for now"
  vpc_id      = aws_vpc.vpc-k8s-sample.id
  ingress {
    description = "Allow port 22 only from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description = "Allow port 80 only for yum"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow all ports within the subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name        = "sg-master-k8s-sample"
    description = "Security group for master in the K8s sample"
    }
  )
}

#Create SG for LB, allow only ports 443,80 and outgoing access
resource "aws_security_group" "sg-lb-k8s-sample" {
  provider    = aws.region-k8s-sample
  name        = "lb-sg"
  description = "Allow TCP over port 80,443"
  vpc_id      = aws_vpc.vpc-k8s-sample.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name        = "sg-lb-k8s-sample"
    description = "Security group for load balancer in the K8s sample"
    }
  )
}


#Create SG for allowing all ports within the subnet for Worker nodes.
resource "aws_security_group" "sg-worker-k8s-sample" {
  provider    = aws.region-k8s-sample
  name        = "worker-sg"
  description = "Allow all ports within the subnet for now"
  ingress {
    description = "Full access within subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}