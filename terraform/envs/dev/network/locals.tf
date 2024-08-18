locals {
  tags = {
    Environment = var.environment
    Owner       = "DevOps"
    Terraform   = "true"
  }
  infra_name = "services"
}