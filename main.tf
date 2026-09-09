locals {
  helm_chart_name                = "aws-for-fluent-bit"
  fluentbit_log_file_starts_with = join("-", [var.helm_release_name, local.helm_chart_name])

  k8s_common_labels = merge(
    var.k8s_default_labels,
    var.k8s_additional_labels,
  )

  exclude_from_application_log_group = sort(distinct(concat(
    var.default_exclude_from_application_log_group,
    var.additional_exclude_from_application_log_group,
    [local.fluentbit_log_file_starts_with]
  )))

  include_in_platform_log_group = sort(distinct(concat(
    var.default_additional_include_in_platform_log_group,
    var.additional_include_in_platform_log_group,
  )))
}

module "iam_assumable_role_with_oidc_for_fluent_bit" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 6.0"

  enable_oidc = true

  # v6 defaults use_name_prefix to true, which would turn the role name into a
  # prefix and rename the live role.
  use_name_prefix = false
  name            = var.aws_fluentbit_role_name

  oidc_provider_urls = [var.cluster_oidc_issuer_host]

  # role_policy_arns stays a list on this module's interface. The keys follow the
  # list index, so the attachment order matches the v5 count-based behaviour.
  policies = { for idx, arn in var.role_policy_arns : "p${idx}" => arn }

  oidc_subjects = [
    "system:serviceaccount:${var.namespace}:${var.k8s_fluentbit_service_account_name}"
  ]
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    labels = merge(
      local.k8s_common_labels,
      {
        name = var.namespace
      }
    )
    name = var.namespace
  }
}

resource "kubernetes_service_account_v1" "this" {
  metadata {
    name      = var.k8s_fluentbit_service_account_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.k8s_common_labels
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_with_oidc_for_fluent_bit.arn
    }
  }
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    labels    = local.k8s_common_labels
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.this.metadata[0].name
    }
    generate_name = "${var.k8s_fluentbit_service_account_name}-"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

resource "helm_release" "this" {
  name             = var.helm_release_name
  repository       = "https://aws.github.io/eks-charts"
  chart            = local.helm_chart_name
  version          = var.helm_chart_version
  namespace        = kubernetes_namespace_v1.this.metadata[0].name
  create_namespace = false

  values = concat(
    [
      templatefile(
        "${path.module}/files/values.yml.tftpl",
        {
          flush_seconds                     = var.fluentbit_flush_seconds
          service_account_name              = kubernetes_service_account_v1.this.metadata[0].name
          aws_region                        = var.aws_region
          cluster_name                      = var.cluster_name
          http_server                       = var.fluentbit_http_server_enabled ? "On" : "Off"
          http_port                         = var.fluentbit_http_server_port
          read_from_head                    = var.fluentbit_read_from_head
          read_from_tail                    = var.fluentbit_read_from_tail
          fluentbit_log_file_starts_with    = local.fluentbit_log_file_starts_with
          send_fluentbit_logs_to_cloudwatch = var.fluentbit_send_fluentbit_logs_to_cloudwatch

          # Fine tune for the log groups
          application_log_retention_days                = var.application_log_retention_days
          platform_log_retention_days                   = var.platform_log_retention_days
          fluentbit_log_retention_days                  = var.fluentbit_log_retention_days
          additional_exclude_from_application_log_group = local.exclude_from_application_log_group
          additional_include_in_platform_log_group      = local.include_in_platform_log_group
          additional_filters                            = var.additional_filters
        }
      ),
    ],
    var.helm_additional_values
  )
}
