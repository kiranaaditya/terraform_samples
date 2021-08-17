#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.kiran
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "terraform_remote_state" "backend_resources" {
  backend = "s3"
  config = {
    bucket = "terraformstatefiles1991"
    key    = "tfsupportingresources.tfstate"
    region = "us-east-1"
  }
}
