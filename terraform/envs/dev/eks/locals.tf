locals {
  tags = {
    Environment = var.environment
    Owner       = "DevOps"
    Terraform   = "true"
  }
  cluster_name    = "services"
  vpc_id          = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_cidr_block  = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
}
