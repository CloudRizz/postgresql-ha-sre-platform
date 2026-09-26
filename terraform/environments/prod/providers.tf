# Configures the AWS provider using the selected deployment region.
provider "aws" {
  region = var.aws_region

  # Automatically applies standard project tags to supported AWS resources.
  default_tags {
    tags = local.common_tags
  }
}
