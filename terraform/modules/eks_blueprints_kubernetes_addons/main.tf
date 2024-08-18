module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.3"

  cluster_name      = var.eks_cluster_id
  cluster_endpoint  = data.aws_eks_cluster.cluster.endpoint
  cluster_version   = data.aws_eks_cluster.cluster.version
  oidc_provider_arn = data.aws_iam_openid_connect_provider.this.arn

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = aws_iam_role.ebs_csi.arn
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent          = true
      configuration_values = var.vpc_cni_configuration_values
    }
    kube-proxy = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller   = var.enable_aws_load_balancer_controller
  enable_aws_cloudwatch_metrics         = var.enable_aws_cloudwatch_metrics
  enable_karpenter                      = var.enable_karpenter
  karpenter                             = var.karpenter
  karpenter_node                        = var.karpenter_node
  enable_metrics_server                 = var.enable_metrics_server
  external_dns_route53_zone_arns        = var.external_dns_route53_zone_arns
  enable_external_dns                   = var.enable_external_dns
  enable_external_secrets               = var.enable_external_secrets
  external_secrets_ssm_parameter_arns   = var.external_secrets_ssm_parameter_arns
  external_secrets_secrets_manager_arns = var.external_secrets_secrets_manager_arns
  external_secrets_kms_key_arns         = var.external_secrets_kms_key_arns
  enable_aws_for_fluentbit              = var.enable_aws_for_fluentbit
  aws_for_fluentbit                     = var.aws_for_fluentbit
  aws_for_fluentbit_cw_log_group        = var.aws_for_fluentbit_cw_log_group
  enable_argocd                         = var.enable_argocd
  argocd                                = var.argocd
  tags                                  = var.tags
}
