resource "aws_s3_bucket" "jenkins_backup_bucket" {
  bucket = "${var.author_name}-${var.project_name}-${var.env_name}-${random_integer.rand.result}-s3-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
  tags = merge(local.common_tags, {
    Name        = "${var.author_name}-${var.project_name}-${var.env_name}-s3-bucket"
    Description = "Permanent s3 bucket created to store the jenkins configuration files"
    }
  )
  lifecycle {
    prevent_destroy = true
  }
}