variable "environment" {
  type        = string
  description = "The name of the environment"
}

# Tags applied to all resources
variable "tags" {
  type = map(string)
}

variable "eks_cluster_id" {
  type = string
}

variable "enable_aws_load_balancer_controller" {
  type    = bool
  default = true
}

variable "enable_aws_cloudwatch_metrics" {
  type    = bool
  default = false
}

variable "enable_metrics_server" {
  description = "Enable metrics server add-on"
  type        = bool
  default     = false
}

variable "enable_external_secrets" {
  description = "Enable External Secrets operator add-on"
  type        = bool
  default     = false
}

variable "external_secrets_ssm_parameter_arns" {
  description = "List of Systems Manager Parameter ARNs that contain secrets to mount using External Secrets"
  type        = list(string)
  default     = ["arn:aws:ssm:*:*:parameter/*"]
}

variable "external_secrets_secrets_manager_arns" {
  description = "List of Secrets Manager ARNs that contain secrets to mount using External Secrets"
  type        = list(string)
  default     = ["arn:aws:secretsmanager:*:*:secret:*"]
}

variable "external_secrets_kms_key_arns" {
  description = "List of KMS Key ARNs that are used by Secrets Manager that contain secrets to mount using External Secrets"
  type        = list(string)
  default     = ["arn:aws:kms:*:*:key/*"]
}

variable "enable_karpenter" {
  type    = bool
  default = false
}

variable "karpenter" {
  description = "Karpenter add-on configuration values"
  type        = any
  default     = {}
}

variable "karpenter_node" {
  description = "Karpenter IAM role and IAM instance profile configuration values"
  type        = any
  default     = {}
}

variable "enable_external_dns" {
  type    = bool
  default = false
}

variable "external_dns_route53_zone_arns" {
  type    = list(string)
  default = []
}

variable "enable_aws_for_fluentbit" {
  description = "Enable AWS for FluentBit add-on"
  type        = bool
  default     = false
}

variable "aws_for_fluentbit" {
  description = "AWS Fluentbit add-on configurations"
  type        = any
  default     = {}
}

variable "aws_for_fluentbit_cw_log_group" {
  description = "AWS Fluentbit CloudWatch Log Group configurations"
  type        = any
  default     = {}
}

variable "enable_argocd" {
  description = "Enable Argo CD Kubernetes add-on"
  type        = bool
  default     = false
}
variable "argocd" {
  description = "ArgoCD add-on configuration values"
  type        = any
  default     = {}
}

variable "vpc_cni_configuration_values" {
  type    = string
  default = null
}
