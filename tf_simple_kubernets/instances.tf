#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-k8s-sample
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-k8s-sample
  key_name   = "k8s-sample"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create a bootstrapped master instance to test
resource "aws_instance" "k8s-master" {
  provider                    = aws.region-k8s-sample
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type-master
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg-master-k8s-sample.id]
  subnet_id                   = aws_subnet.subnet-k8s-sample.id
  tags = merge(local.common_tags, {
    Name        = "master-k8s-sample"
    Description = "Master instance for K8s sample"
    }
  )
}

#Create a bootstrapped worker instance to test
resource "aws_instance" "k8s_worker" {
  provider                    = aws.region-k8s-sample
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type-worker
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.sg-worker-k8s-sample.id]
  subnet_id                   = aws_subnet.subnet-k8s-sample.id
  tags = merge(local.common_tags, {
    Name        = "worker-k8s-sample"
    Description = "Worker instance for K8s sample"
    }
  )
}