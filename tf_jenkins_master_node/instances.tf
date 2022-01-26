#Create a bootstrapped master instance to test
resource "aws_instance" "jenkins-master" {
  provider      = aws.kiran
  ami           = "ami-0b0af3577fe5e3532" #data.aws_ssm_parameter.linuxAmi.value
  instance_type = var.instance-type-master
  # key_name                    = data.terraform_remote_state.backend_resources.outputs.aws_key
  key_name                    = aws_key_pair.kiran-key.key_name
  associate_public_ip_address = true
  security_groups             = [data.terraform_remote_state.backend_resources.outputs.security_group]
  subnet_id                   = data.terraform_remote_state.backend_resources.outputs.subnet
  iam_instance_profile        = data.terraform_remote_state.backend_resources.outputs.iam_instance_profile_name
  provisioner "local-exec" {
    command = <<EOF
    aws --profile ${data.terraform_remote_state.backend_resources.outputs.profile} ec2 wait instance-status-ok --region ${data.terraform_remote_state.backend_resources.outputs.region} --instance-ids ${self.id} \
    && ansible-playbook --extra-vars 'passed_in_hosts=tag_Role_${self.tags.Role}' ansible_playbooks/jenkins-master_playbook.yml -i ansible_playbooks/inventory_aws/tf_aws_ec2.yml
    EOF
  }
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "sudo su jenkins -c '/usr/local/bin/backup-jenkins --bucket=aaditya-backend-prod-4079847-s3-bucket create'"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
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
  provider                    = aws.kiran
  ami                         = "ami-0b0af3577fe5e3532" #data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type-slave
  key_name                    = aws_key_pair.kiran-key.key_name
  associate_public_ip_address = true
  security_groups             = [data.terraform_remote_state.backend_resources.outputs.security_group]
  subnet_id                   = data.terraform_remote_state.backend_resources.outputs.subnet
  provisioner "local-exec" {
    command = <<EOF
    aws --profile ${data.terraform_remote_state.backend_resources.outputs.profile} ec2 wait instance-status-ok --region ${data.terraform_remote_state.backend_resources.outputs.region} --instance-ids ${self.id} \
    && ansible-playbook --extra-vars 'passed_in_hosts=tag_Role_${self.tags.Role}' ansible_playbooks/jenkins-slave_playbook.yml -i ansible_playbooks/inventory_aws/tf_aws_ec2.yml
    EOF
  }
  tags = merge(data.terraform_remote_state.backend_resources.outputs.local_common_tags, {
    Name        = "${data.terraform_remote_state.backend_resources.outputs.author_name}_${data.terraform_remote_state.backend_resources.outputs.project_name}_${data.terraform_remote_state.backend_resources.outputs.env_name}_node"
    Description = "Node instance for jenkins env"
    Role        = "node"
    }
  )
}
