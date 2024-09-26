variable "namespace" {
  description = "The namespace in which the Fluent Bit resources will be created."
  type        = string
  default     = "amazon-cloudwatch"
}

variable "helm_release_name" {
  description = "The name of the Helm release."
  type        = string
  default     = "fluentbit"
}

variable "helm_chart_version" {
  description = "The version of the aws-for-fluent-bit Helm chart."
  type        = string
  default     = "0.1.34"
}

variable "helm_additional_values" {
  description = "Additional values to be passed to the Helm chart."
  type        = list(string)
  default     = []
}

variable "k8s_default_labels" {
  description = "Labels to apply to the kubernetes resources. These are opinionated labels, you can add more labels using the variable `additional_k8s_labels`. If you want to remove a label, you can override it with an empty map(string)."
  type        = map(string)
  default = {
    managed-by = "terraform"
    scope      = "fluentbit"
  }
}

variable "k8s_additional_labels" {
  description = "Additional labels to apply to the kubernetes resources."
  type        = map(string)
  default     = {}
}

variable "k8s_fluentbit_service_account_name" {
  description = "The name of the Kubernetes service account for FluentBit."
  type        = string
  default     = "fluentbit"
}

variable "aws_region" {
  description = "The AWS region used to send logs to CloudWatch."
  type        = string
}

variable "aws_fluentbit_role_name" {
  description = "The name of the IAM role for FluentBit."
  type        = string
  default     = "fluentbit"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_oidc_issuer_host" {
  description = "The OIDC issuer host for the EKS cluster."
  type        = string
}

variable "role_policy_arns" {
  description = "The ARNs of the policies to attach to the IAM role."
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  ]
}

variable "fluentbit_flush_seconds" {
  description = "The interval in seconds to flush the logs to CloudWatch."
  type        = number
  default     = 15
}

variable "fluentbit_http_server_enabled" {
  description = "Enable the HTTP server for fluentbit."
  type        = bool
  default     = false
}

variable "fluentbit_http_server_port" {
  description = "Port for the HTTP server."
  type        = number
  default     = 2020
}

variable "fluentbit_read_from_head" {
  description = "Start reading from the beginning of the log stream. Keep also the entries already stored."
  type        = string
  default     = "Off"
}

variable "fluentbit_read_from_tail" {
  description = "Start reading new entries. Skip entries already stored."
  type        = string
  default     = "On"
}

variable "fluentbit_send_fluentbit_logs_to_cloudwatch" {
  description = "Send FluentBit logs to CloudWatch."
  type        = bool
  default     = true
}

variable "default_exclude_from_application_log_group" {
  description = "List of log files to exclude from the application log group. This list is intended for the log files of the system AWS EKS applications, use the variable `additional_exclude_from_application_log_group` to exclude custom log files. The element of this list will be prefixed with `/var/log/containers/` and suffixed with `*.log`."
  type        = list(string)
  default = [
    "aws-load-balancer-controller",
    "aws-node",
    "cluster-autoscaler-aws-cluster-autoscaler",
    "coredns",
    "ebs-csi-controller",
    "ebs-csi-node",
    "efs-csi-controller",
    "efs-csi-node",
    "kube-proxy",
    "metric-server-metrics-server",
  ]
}

variable "additional_exclude_from_application_log_group" {
  description = "List of additional log files to exclude from the application log group. The element of this list will be prefixed with `/var/log/containers/` and suffixed with `*.log`."
  type        = list(string)
  default     = []
}

variable "default_additional_include_in_platform_log_group" {
  description = "List of log files to include in the platform log group. This list is intended for the log files of the system AWS EKS applications, use the variable `additional_include_in_platform_log_group` to include custom log files. The element of this list will be prefixed with `/var/log/containers/` and suffixed with `*.log`."
  type        = list(string)
  default = [
    "ebs-csi-controller",
    "ebs-csi-node",
    "efs-csi-controller",
    "efs-csi-node",
  ]
}

variable "additional_include_in_platform_log_group" {
  description = "List of additional log files to include in the platform log group. The element of this list will be prefixed with `/var/log/containers/` and suffixed with `*.log`."
  type        = list(string)
  default     = []
}

variable "additional_filters" {
  description = "Filter block(s) to add to the FluentBit configuration. The filter block(s) must be in the format of a string."
  type        = string
  default     = ""
}

variable "application_log_retention_days" {
  description = "The retention period for the application log group. Remember to check the valid values for the retention period in the AWS CloudWatch documentation."
  type        = number
  default     = 30
}

variable "platform_log_retention_days" {
  description = "The retention period for the platform log group. Remember to check the valid values for the retention period in the AWS CloudWatch documentation."
  type        = number
  default     = 14
}

variable "fluentbit_log_retention_days" {
  description = "The retention period for the FluentBit log group. Remember to check the valid values for the retention period in the AWS CloudWatch documentation."
  type        = number
  default     = 3
}
