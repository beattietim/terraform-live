provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket  = "beattie-aws-terraform-state"
    key     = "stage/services/webserver-cluster/terraform.tfstate"
    region  = "us-west-1"

    dynamodb_table  = "beattie-aws-terraform-state-locks"
    encrypt         = true
  }
}

module "webserver_cluster" {
  source = "..\/..\/..\/..\/modules\/services\/webserver-cluster"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "beattie-aws-terraform-state"
  db_remote_state_key = "stage/data-store/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size = 2
  max_size = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}