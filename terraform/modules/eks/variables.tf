variable "aws_auth_accounts" {
  description = "List of account maps to add to the aws-auth configmap	"
  type        = list(string)
  default     = []
}

variable "user_mappings" {
  description = "List of IAM user ARNs to add the groups to add them to"
  type = list(object({
    username = string
    arn      = string
    groups   = list(string)
  }))
  default = []
}

variable "role_mappings" {
  description = "List of IAM role ARNs and the groups to add them to"
  type = list(object({
    username = string
    arn      = string
    groups   = list(string)
  }))
  default = []
}

variable "cluster" {
  description = "An object representing the desired cluster configurations"
  type = object({
    name                  = string
    version               = string
    ipv4_cidr             = string
    log_retention_in_days = number
  })
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source"
  type        = any
  default     = {}
}

variable "environment" {
  description = "The name of the environment being deployed"
  type        = string
}

variable "cluster_ip_family" {
  description = "The IP family used to assign Kubernetes pod and service addresses. Valid values are `ipv4` (default) and `ipv6`. You can only specify an IP family when you create a cluster, changing this value will force a new cluster to be created"
  type        = string
  default     = "ipv4"
}

variable "node_groups" {
  description = "The configuration for the cluster node groups"
  type = list(
    object({
      name                         = string
      capacity_type                = string
      instance_types               = list(string)
      min_size                     = number
      max_size                     = number
      desired_size                 = number
      disk_size                    = number
      labels                       = map(string)
      taints                       = any
      ami_id                       = string
      network_interfaces           = list(any)
      launch_template_tags         = map(string)
      iam_role_additional_policies = map(string)
    })
  )
}

# variable "node_security_group_id" {
#   description = "VPC security group to be applied to the node groups"
#   type        = string
# }

variable "tags" {
  description = "The tags to apply to resources which override the provider default tags"
  type        = map(string)
  default     = {}
}

variable "vpc" {
  description = "An object representing the VPC configuration for the VPC the cluster will run in"
  type = object({
    id      = string
    subnets = list(string)
  })
}
