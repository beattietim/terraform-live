provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket  = "beattie-aws-terraform-state"
    key     = "prod/data-store/mysql/terraform.tfstate"
    region  = "us-west-1"

    dynamodb_table  = "beattie-aws-terraform-state-locks"
    encrypt         = true
  }
}

module "mysql" {
  source = "..\/..\/..\/..\/modules\/data-stores\/mysql"

  cluster_name = "db-prod"
  db_password   = var.db_password
}