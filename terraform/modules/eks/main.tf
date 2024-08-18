locals {
  account_partition = data.aws_partition.current.partition
}


data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  description = "${var.cluster.name} EKS Secret Encryption Key"
}

data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}

data "aws_iam_policy_document" "eks_kms_secrets" {
  statement {
    sid    = "AllowEKSSecretKMSAccess"
    effect = "Allow"

    actions = [
      "kms:ListGrants"
    ]

    resources = [
      aws_kms_key.this.arn
    ]
  }
}

locals {
  node_pre_userdata = <<-EOF
    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
  EOF

  map_users = [
    for user in var.user_mappings : {
      userarn  = user.arn
      username = user.username
      groups   = user.groups
    }
  ]

  map_roles = [
    for role in var.role_mappings : {
      rolearn  = role.arn
      username = role.username
      groups   = role.groups
    }
  ]

  cluster_node_groups = {
    for node_group in var.node_groups : node_group.name => {
      name                    = node_group.name
      desired_size            = node_group.desired_size
      max_size                = node_group.max_size
      min_size                = node_group.min_size
      capacity_type           = node_group.capacity_type
      instance_types          = node_group.instance_types
      create_launch_template  = true
      create_security_group   = false
      subnets                 = var.vpc.subnets
      pre_bootstrap_user_data = local.node_pre_userdata
      taints                  = node_group.taints
      ami_id                  = node_group.ami_id
      network_interfaces      = node_group.network_interfaces
      launch_template_tags    = node_group.launch_template_tags

      iam_role_additional_policies = merge(
        {
          AmazonSSMManagedInstanceCoreARN = "arn:${local.account_partition}:iam::aws:policy/AmazonSSMManagedInstanceCore",
          CloudWatchAgentServerPolicy     = "arn:${local.account_partition}:iam::aws:policy/CloudWatchAgentServerPolicy"
        },
        node_group.iam_role_additional_policies
      )
      block_device_mappings = [{
        device_name = "/dev/xvda"
        ebs = {
          encrypted   = true
          kms_key_id  = data.aws_kms_key.ebs.arn
          volume_size = node_group.disk_size
          volume_type = "gp3"
        }
      }]

      taints = node_group.taints

      labels = merge(node_group.labels, {
        environment = var.environment
      })
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = var.cluster.name
  cluster_version = var.cluster.version

  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.this.arn
    resources        = ["secrets"]
  }

  subnet_ids                              = var.vpc.subnets
  control_plane_subnet_ids                = var.vpc.subnets
  vpc_id                                  = var.vpc.id
  cluster_ip_family                       = var.cluster_ip_family
  create_cluster_security_group           = true
  create_node_security_group              = true
  cluster_enabled_log_types               = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  cloudwatch_log_group_retention_in_days  = var.cluster.log_retention_in_days
  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  manage_aws_auth_configmap               = true
  aws_auth_users                          = local.map_users
  aws_auth_roles                          = local.map_roles

  eks_managed_node_groups = local.cluster_node_groups

  tags = var.tags
  node_security_group_tags = {
    "kubernetes.io/cluster/${var.cluster.name}" = null
  }
}
