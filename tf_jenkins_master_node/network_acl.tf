# Create a network ACL for master slave servers
resource "aws_network_acl" "nacl-master-slave-jenkins" {
  vpc_id     = aws_vpc.vpc-jenkins.id
  provider   = aws.region-jenkins
  subnet_ids = [aws_subnet.subnet-jenkins-master-slave.id]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8090
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = format("%s/%s", data.external.whatsmyip.result["internet_ip"], 32)
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8090
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = format("%s/%s", data.external.whatsmyip.result["internet_ip"], 32)
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  depends_on = [aws_subnet.subnet-jenkins-master-slave]
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}-${data.terraform_remote_state.backend_resources.outputs.project_name}-${data.terraform_remote_state.backend_resources.outputs.env_name}-nacl"
    Description = "NACL for jenkins env"
    Role        = "Security"
    }
  )
}

