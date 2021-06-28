# Get my external IP and store it as a data
data "external" "whatsmyip" {
  program = ["/bin/bash", "${path.module}/whatsmyip.sh"]
}

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-edureka
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get Linux AMI ID using SSM Parameter endpoint in us-east-1 for jump server
#data "aws_ssm_parameter" "jumpAmi" {
#  provider = aws.region-edureka
#  name     = "/aws/service/"
#}