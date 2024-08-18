module "services_cluster" {
  source                         = "../../../modules/eks"
  environment                    = var.environment
  cluster_endpoint_public_access = true
  tags                           = local.tags
  cluster = {
    name                  = "${local.cluster_name}-${var.environment}"
    version               = "1.30"
    ipv4_cidr             = null
    log_retention_in_days = 90
  }
  vpc = {
    id      = local.vpc_id
    subnets = local.private_subnets
  }
  node_groups = [
    {
      name          = "shared"
      capacity_type = "ON_DEMAND"
      instance_types = [
        "t3.medium"
      ]
      desired_size                 = 2
      min_size                     = 2
      max_size                     = 5
      disk_size                    = 50
      labels                       = {}
      taints                       = []
      ami_id                       = ""
      network_interfaces           = []
      launch_template_tags         = {}
      iam_role_additional_policies = {}
    }
  ]
  cluster_security_group_additional_rules = {
    cluster_ingress_https_local = {
      description = "Allow HTTPS access to cluster from local network"
      protocol    = "tcp"
      cidr_blocks = [local.vpc_cidr_block]
      from_port   = 443
      to_port     = 443
      type        = "ingress"
    }
  }
}
