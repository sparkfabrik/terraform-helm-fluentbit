variable "k8s_labels" {
  description = "Labels to apply to the kubernetes resources."
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "The AWS region used to send logs to CloudWatch."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_oidc_issuer_host" {
  description = "The OIDC issuer host for the EKS cluster."
  type        = string
}
