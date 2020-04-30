provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket  = "beattie-aws-terraform-state"
    key     = "prod/services/webserver-cluster/terraform.tfstate"
    region  = "us-west-1"

    dynamodb_table  = "beattie-aws-terraform-state-locks"
    encrypt         = true
  }
}

module "webserver_cluster" {
  source = "..\/..\/..\/..\/modules\/services\/webserver-cluster"

  cluster_name = "webservers-prod"
  db_remote_state_bucket = "beattie-aws-terraform-state"
  db_remote_state_key = "prod/data-store/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size = 2
  max_size = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  autoscaling_group_name  = module.webserver_cluster.asg_name
  scheduled_action_name   = "scale-out-during-business-hours"
  min_size                = 2
  max_size                = 10
  desired_capacity        = 10
  recurrence              = "0 9 * * *"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  autoscaling_group_name  = module.webserver_cluster.asg_name
  scheduled_action_name   = "scale-in-at-night"
  min_size                = 2
  max_size                = 10
  desired_capacity        = 2
  recurrence              = "0 17 * * *"
}