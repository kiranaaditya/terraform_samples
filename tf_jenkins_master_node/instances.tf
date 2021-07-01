#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "jenkins-key" {
  provider   = aws.region-jenkins
  key_name   = "jenkins"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create a bootstrapped master instance to test
resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-jenkins
  ami                         = "ami-0b0af3577fe5e3532" #data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type-master
  key_name                    = aws_key_pair.jenkins-key.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg-master-node-jenkins.id]
  subnet_id                   = aws_subnet.subnet-jenkins-master-slave.id
  iam_instance_profile        = data.terraform_remote_state.backend_resources.outputs.iam_instance_profile_name
  provisioner "local-exec" {
    command = <<EOF
    aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-jenkins} --instance-ids ${self.id} \
    && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_playbooks/jenkins-master_playbook.yml -i ansible_playbooks/inventory_aws/tf.aws_ec2.yml
    EOF
  }
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}_${data.terraform_remote_state.backend_resources.outputs.project_name}_${data.terraform_remote_state.backend_resources.outputs.env_name}_master"
    Description = "Master instance for jenkins env"
    Role        = "master"
    }
  )
}

#Create a bootstrapped worker instance to test
resource "aws_instance" "jenkins-node" {
  provider                    = aws.region-jenkins
  ami                         = "ami-0b0af3577fe5e3532" #data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type-slave
  key_name                    = aws_key_pair.jenkins-key.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg-master-node-jenkins.id]
  subnet_id                   = aws_subnet.subnet-jenkins-master-slave.id
  provisioner "local-exec" {
    command = <<EOF
    aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-jenkins} --instance-ids ${self.id} \
    && ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_playbooks/jenkins-slave_playbook.yml
    EOF
  }
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}_${data.terraform_remote_state.backend_resources.outputs.project_name}_${data.terraform_remote_state.backend_resources.outputs.env_name}_node"
    Description = "Node instance for jenkins env"
    Role        = "node"
    }
  )
}
