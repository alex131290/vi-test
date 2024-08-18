variable "environment" {
  default = "dev"
}

variable "region" {
  default = "eu-west-1"
}

variable "ecr_repositories_names" {
  type    = set(string)
  default = ["service1_dev"]
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}
