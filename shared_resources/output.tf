# General outputs

output "region" {
  value = var.region
}

# output "provider" {
#   value = provider.aws
# }

# output "aws_key" {
#   value = aws_key_pair.kiran-key.key_name
# }

output "profile" {
  value = var.profile
}

#############################################################################################

# Tag outputs
output "project_name" {
  value = var.project_name
}

output "env_name" {
  value = var.env_name
}

output "author_name" {
  value = var.author_name
}

output "local_common_tags" {
    value = local.common_tags
}

#############################################################################################

# S3 bucket arn

output "jenkins_backup_bucket_arn" {
  value = aws_s3_bucket.jenkins_backup_bucket.arn
}

#############################################################################################

# IAM instance profile name

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_s3_bucket_profile.name
}

#############################################################################################

# Network outputs

output "subnet" {
  value = aws_subnet.subnet-kiran.id
}

#############################################################################################

# Security outputs

output "security_group" {
  value = aws_security_group.sg-kiran.id
}

#############################################################################################
