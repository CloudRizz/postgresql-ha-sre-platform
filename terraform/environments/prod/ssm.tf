# Creates the private S3 bucket used for temporary Ansible SSM file transfers.
resource "aws_s3_bucket" "ansible_ssm" {
  bucket_prefix = "${local.name_prefix}-ansible-ssm-"
  force_destroy = true
}

# Blocks all public access to the Ansible SSM transfer bucket.
resource "aws_s3_bucket_public_access_block" "ansible_ssm" {
  bucket = aws_s3_bucket.ansible_ssm.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Encrypts temporary Ansible transfer objects using Amazon S3 managed encryption.
resource "aws_s3_bucket_server_side_encryption_configuration" "ansible_ssm" {
  bucket = aws_s3_bucket.ansible_ssm.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Removes abandoned Ansible transfer objects after one day.
resource "aws_s3_bucket_lifecycle_configuration" "ansible_ssm" {
  bucket = aws_s3_bucket.ansible_ssm.id

  rule {
    id     = "expire-ansible-transfers"
    status = "Enabled"

    filter {}

    expiration {
      days = 1
    }
  }
}
