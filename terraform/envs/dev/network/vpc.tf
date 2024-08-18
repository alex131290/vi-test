module "app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "${local.infra_name}-${var.environment}"
  cidr = "10.10.0.0/16"
  # always better to have more AZs
  azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  # 4096 IPs per subnet, trying to make it as big as possible to avoid potential issues
  private_subnets = ["10.10.16.0/20", "10.10.32.0/20", "10.10.48.0/20"]
  public_subnets  = ["10.10.64.0/20", "10.10.80.0/20", "10.10.96.0/20"]

  enable_nat_gateway     = true
  enable_vpn_gateway     = true
  one_nat_gateway_per_az = true

  tags = local.tags
}
