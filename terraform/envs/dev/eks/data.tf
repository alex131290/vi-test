data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "vi-terraform-state-test"
    key    = "terraform/dev-eu-west-1/networking.tfstate"
    region = var.region
  }
}
