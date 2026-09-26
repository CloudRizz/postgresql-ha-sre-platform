# Configures S3 remote state with native state locking for the production environment.
terraform {
  backend "s3" {
    key          = "prod/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
