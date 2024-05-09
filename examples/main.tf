module "fluentbit" {
  source  = "github.com/sparkfabrik/terraform-helm-fluentbit"
  version = ">= 0.1.0"

  k8s_additional_labels    = var.k8s_labels
  aws_region               = var.aws_region
  cluster_name             = var.cluster_name
  cluster_oidc_issuer_host = var.cluster_oidc_issuer_host
}
