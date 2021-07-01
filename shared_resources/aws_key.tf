#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "kiran-key" {
  provider   = aws.region-kiran
  key_name   = "kiran"
  public_key = file("~/.ssh/id_rsa.pub")
}