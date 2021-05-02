#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "edureka-key" {
  provider   = aws.region-edureka
  key_name   = "edureka"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create a bootstrapped master instance to test
resource "aws_instance" "edureka-master" {
  provider                    = aws.region-edureka
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type-master
  key_name                    = aws_key_pair.edureka-key.key_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.sg-master-edureka.id]
  subnet_id                   = aws_subnet.subnet-edureka-master-slave.id
  tags = merge(local.common_tags, {
    Name        = "edureka-master"
    Description = "Master instance for edureka env"
    }
  )
}

#Create a bootstrapped worker instance to test
resource "aws_instance" "edureka-slave" {
  provider                    = aws.region-edureka
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type-slave
  key_name                    = aws_key_pair.edureka-key.key_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.sg-slave-edureka.id]
  subnet_id                   = aws_subnet.subnet-edureka-master-slave.id
  tags = merge(local.common_tags, {
    Name        = "edureka-slave"
    Description = "Slave instance for edureka env"
    }
  )
}

#Create a jump server 
resource "aws_instance" "edureka-jump" {
  provider                    = aws.region-edureka
  ami                         = "ami-00a9d4a05375b2763"
  instance_type               = var.instance-type-jump
  key_name                    = aws_key_pair.edureka-key.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg-jump-edureka.id]
  subnet_id                   = aws_subnet.subnet-edureka-jump.id
  tags = merge(local.common_tags, {
    Name        = "jump-edureka"
    Description = "Jump server for edureka env"
  })
}