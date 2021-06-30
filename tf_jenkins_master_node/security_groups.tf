#Create SG for allowing all ports within the subnet for Master nodes.
resource "aws_security_group" "sg-master-node-jenkins" {
  provider    = aws.region-jenkins
  name        = "jenkins-master-node"
  description = "Access is restricted with NACL"
  vpc_id      = aws_vpc.vpc-jenkins.id
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
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}-${data.terraform_remote_state.backend_resources.outputs.project_name}-${data.terraform_remote_state.backend_resources.outputs.env_name}-sg"
    Description = "Security group for jenkins env"
    Role        = "Security"
    }
  )
}

