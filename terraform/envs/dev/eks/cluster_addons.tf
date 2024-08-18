module "services_cluster_addons" {
  source                              = "../../../modules/eks_blueprints_kubernetes_addons"
  environment                         = var.environment
  eks_cluster_id                      = module.services_cluster.cluster_name
  enable_external_secrets             = true
  enable_metrics_server               = true
  enable_aws_load_balancer_controller = true
  enable_aws_for_fluentbit            = true
  aws_for_fluentbit_cw_log_group = {
    create          = true
    use_name_prefix = true # Set this to true to enable name prefix
    name_prefix     = "${module.services_cluster.cluster_name}-cluster-logs-"
    retention       = 7
  }
  aws_for_fluentbit = {
    enable_containerinsights = true
    chart_version            = "0.1.32"
    application_log_conf     = templatefile("./templates/fluentbit_app_conf.tpl", {})
    fluentbit_conf           = templatefile("./templates/fluentbit_conf.tpl", {})
  }
  enable_aws_cloudwatch_metrics = true
  tags                          = local.tags
}