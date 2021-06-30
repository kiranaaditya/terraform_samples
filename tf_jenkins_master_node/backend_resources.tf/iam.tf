resource "aws_iam_policy" "aws_ec2_s3" {
  name = "aws_ec2_my-jenkins-backup-bucket_rw_access"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : [
          "${aws_s3_bucket.jenkins_backup_bucket.arn}"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.jenkins_backup_bucket.arn}/*"
        ]
      }
    ]
  })
  tags = merge(local.common_tags, {
    Name        = "${var.author_name}-${var.project_name}-${var.env_name}-iam-policy"
    Description = "Read and write access for ec2 instances to a bucket my-jenkins-backup-bucket"
    }
  )
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "ec2_s3_bucket" {
  name = "ec2_access_to_S3_bucket"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags = merge(local.common_tags, {
    Name        = "${var.author_name}-${var.project_name}-${var.env_name}-iam-role"
    Description = "Read and write access for ec2 instances to a bucket my-jenkins-backup-bucket"
    }
  )
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.ec2_s3_bucket.name
  policy_arn = aws_iam_policy.aws_ec2_s3.arn
}

resource "aws_iam_instance_profile" "ec2_s3_bucket_profile" {
  name       = "ec2_access_to_S3_bucket_profile"
  role       = aws_iam_role.ec2_s3_bucket.name
  depends_on = [aws_iam_role.ec2_s3_bucket]
  tags = merge(local.common_tags, {
    Name        = "${var.author_name}-${var.project_name}-${var.env_name}-iam-instance-profile"
    Description = "Read and write access for ec2 instances to a bucket my-jenkins-backup-bucket"
    }
  )
  lifecycle {
    prevent_destroy = true
  }
}