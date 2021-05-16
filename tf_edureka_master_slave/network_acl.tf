
# Create a network ACL for jump server
resource "aws_network_acl" "nacl-jump-edureka" {
    vpc_id = aws_vpc.vpc-edureka.id
    provider = aws.region-edureka
    subnet_ids = [aws_subnet.subnet-edureka-jump.id]
    ingress {
        protocol = "tcp"
        rule_no = 200
        action = "allow"
        cidr_block = format("%s/%s", data.external.whatsmyip.result["internet_ip"], 32)
        from_port = 22
        to_port = 22
  } 
    ingress {
        protocol = "tcp"
        rule_no = 300
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 1024
        to_port = 65535
  }
    egress {
        protocol = "tcp"
        rule_no = 200
        action = "allow"
        cidr_block = format("%s/%s", data.external.whatsmyip.result["internet_ip"], 32)
        from_port = 22
        to_port = 22
  } 
    egress {
        protocol = "tcp"
        rule_no = 300
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 1024
        to_port = 65535
  }
  depends_on = [aws_subnet.subnet-edureka-jump]

}

# Create a network ACL for master slave servers
resource "aws_network_acl" "nacl-master-slave-edureka" {
    vpc_id = aws_vpc.vpc-edureka.id
    provider = aws.region-edureka
    subnet_ids = [aws_subnet.subnet-edureka-master-slave.id]
    ingress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 80
        to_port    = 80
  }
    ingress {
        protocol = "tcp"
        rule_no = 200
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 22
        to_port = 22
  } 
    ingress {
        protocol = "tcp"
        rule_no = 300
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 1024
        to_port = 65535
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
        protocol = "tcp"
        rule_no = 200
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 22
        to_port = 22
  } 
    egress {
        protocol = "tcp"
        rule_no = 300
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 1024
        to_port = 65535
  }
  depends_on = [aws_subnet.subnet-edureka-master-slave]


}

