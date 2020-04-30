provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket  = "beattie-aws-terraform-state"
    key     = "global/s3/terraform.tfstate"
    region  = "us-west-1"

    dynamodb_table  = "beattie-aws-terraform-state-locks"
    encrypt         = true
  }
}
resource "aws_s3_bucket" "terraform_state" {
  bucket = "beattie-aws-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name          = "beattie-aws-terraform-state-locks"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}