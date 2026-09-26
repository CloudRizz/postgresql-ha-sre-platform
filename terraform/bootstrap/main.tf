# Generates a persistent random suffix for the globally unique S3 bucket name.
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Creates the temporary S3 bucket used to store Terraform remote state.
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project_name}-tfstate-${random_id.bucket_suffix.hex}"

  # Allows full teardown of temp lab; production state buckets should use prevent_destroy instead.
  force_destroy = true

  tags = {
    Name      = "${var.project_name}-tfstate"
    Project   = var.project_name
    ManagedBy = "Terraform"
    Purpose   = "TerraformState"
  }
}

# Enables versioning so previous Terraform state versions can be recovered.
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypts Terraform state stored inside the S3 bucket.
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Blocks all form of public access to the terraform state bucket.
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
