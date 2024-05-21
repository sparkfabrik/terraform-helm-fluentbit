# FluentBit installation on Amazon EKS

This module installs FluentBit on Amazon EKS and create the necessary resources to send logs to CloudWatch.

It also opinionatedly configures FluentBit to send logs to CloudWatch and to exclude some log files from the application log group and include some log files in the platform log group. You can customize this behavior by using the dedicated variables.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.23 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_exclude_from_application_log_group"></a> [additional\_exclude\_from\_application\_log\_group](#input\_additional\_exclude\_from\_application\_log\_group) | List of additional log files to exclude from the application log group. The element of this list will be prefixed with `/var/log/containers/` and suffixed with `*.log`. | `list(string)` | `[]` | no |
| <a name="input_additional_filters"></a> [additional\_filters](#input\_additional\_filters) | Filter block(s) to add to the FluentBit configuration. The filter block(s) must be in the format of a string. | `string` | `""` | no |
| <a name="input_additional_include_in_platform_log_group"></a> [additional\_include\_in\_platform\_log\_group](#input\_additional\_include\_in\_platform\_log\_group) | List of additional log files to include in the platform log group. The element of this list will be prefixed with `/var/log/containers/` and suffixed with `*.log`. | `list(string)` | `[]` | no |
| <a name="input_application_log_retention_days"></a> [application\_log\_retention\_days](#input\_application\_log\_retention\_days) | The retention period for the application log group. Remember to check the valid values for the retention period in the AWS CloudWatch documentation. | `number` | `30` | no |
| <a name="input_aws_fluentbit_role_name"></a> [aws\_fluentbit\_role\_name](#input\_aws\_fluentbit\_role\_name) | The name of the IAM role for FluentBit. | `string` | `"fluentbit"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region used to send logs to CloudWatch. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster. | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_host"></a> [cluster\_oidc\_issuer\_host](#input\_cluster\_oidc\_issuer\_host) | The OIDC issuer host for the EKS cluster. | `string` | n/a | yes |
| <a name="input_default_additional_include_in_platform_log_group"></a> [default\_additional\_include\_in\_platform\_log\_group](#input\_default\_additional\_include\_in\_platform\_log\_group) | List of log files to include in the platform log group. This list is intended for the log files of the system AWS EKS applications, use the variable `additional_include_in_platform_log_group` to include custom log files. The element of this list will be prefixed with `/var/log/containers/` and suffixed with `*.log`. | `list(string)` | <pre>[<br>  "ebs-csi-controller",<br>  "ebs-csi-node",<br>  "efs-csi-controller",<br>  "efs-csi-node"<br>]</pre> | no |
| <a name="input_default_exclude_from_application_log_group"></a> [default\_exclude\_from\_application\_log\_group](#input\_default\_exclude\_from\_application\_log\_group) | List of log files to exclude from the application log group. This list is intended for the log files of the system AWS EKS applications, use the variable `additional_exclude_from_application_log_group` to exclude custom log files. The element of this list will be prefixed with `/var/log/containers/` and suffixed with `*.log`. | `list(string)` | <pre>[<br>  "aws-load-balancer-controller",<br>  "aws-node",<br>  "cluster-autoscaler-aws-cluster-autoscaler",<br>  "coredns",<br>  "ebs-csi-controller",<br>  "ebs-csi-node",<br>  "efs-csi-controller",<br>  "efs-csi-node",<br>  "kube-proxy",<br>  "metric-server-metrics-server"<br>]</pre> | no |
| <a name="input_fluentbit_flush_seconds"></a> [fluentbit\_flush\_seconds](#input\_fluentbit\_flush\_seconds) | The interval in seconds to flush the logs to CloudWatch. | `number` | `15` | no |
| <a name="input_fluentbit_http_server_enabled"></a> [fluentbit\_http\_server\_enabled](#input\_fluentbit\_http\_server\_enabled) | Enable the HTTP server for fluentbit. | `bool` | `false` | no |
| <a name="input_fluentbit_http_server_port"></a> [fluentbit\_http\_server\_port](#input\_fluentbit\_http\_server\_port) | Port for the HTTP server. | `number` | `2020` | no |
| <a name="input_fluentbit_log_retention_days"></a> [fluentbit\_log\_retention\_days](#input\_fluentbit\_log\_retention\_days) | The retention period for the FluentBit log group. Remember to check the valid values for the retention period in the AWS CloudWatch documentation. | `number` | `3` | no |
| <a name="input_fluentbit_read_from_head"></a> [fluentbit\_read\_from\_head](#input\_fluentbit\_read\_from\_head) | Start reading from the beginning of the log stream. Keep also the entries already stored. | `string` | `"Off"` | no |
| <a name="input_fluentbit_read_from_tail"></a> [fluentbit\_read\_from\_tail](#input\_fluentbit\_read\_from\_tail) | Start reading new entries. Skip entries already stored. | `string` | `"On"` | no |
| <a name="input_fluentbit_send_fluentbit_logs_to_cloudwatch"></a> [fluentbit\_send\_fluentbit\_logs\_to\_cloudwatch](#input\_fluentbit\_send\_fluentbit\_logs\_to\_cloudwatch) | Send FluentBit logs to CloudWatch. | `bool` | `true` | no |
| <a name="input_helm_additional_values"></a> [helm\_additional\_values](#input\_helm\_additional\_values) | Additional values to be passed to the Helm chart. | `list(string)` | `[]` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | The version of the aws-for-fluent-bit Helm chart. | `string` | `"0.1.32"` | no |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | The name of the Helm release. | `string` | `"fluentbit"` | no |
| <a name="input_k8s_additional_labels"></a> [k8s\_additional\_labels](#input\_k8s\_additional\_labels) | Additional labels to apply to the kubernetes resources. | `map(string)` | `{}` | no |
| <a name="input_k8s_default_labels"></a> [k8s\_default\_labels](#input\_k8s\_default\_labels) | Labels to apply to the kubernetes resources. These are opinionated labels, you can add more labels using the variable `additional_k8s_labels`. If you want to remove a label, you can override it with an empty map(string). | `map(string)` | <pre>{<br>  "managed-by": "terraform",<br>  "scope": "fluentbit"<br>}</pre> | no |
| <a name="input_k8s_fluentbit_service_account_name"></a> [k8s\_fluentbit\_service\_account\_name](#input\_k8s\_fluentbit\_service\_account\_name) | The name of the Kubernetes service account for FluentBit. | `string` | `"fluentbit"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace in which the Fluent Bit resources will be created. | `string` | `"amazon-cloudwatch"` | no |
| <a name="input_platform_log_retention_days"></a> [platform\_log\_retention\_days](#input\_platform\_log\_retention\_days) | The retention period for the platform log group. Remember to check the valid values for the retention period in the AWS CloudWatch documentation. | `number` | `14` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | The ARNs of the policies to attach to the IAM role. | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess",<br>  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_final_exclude_from_application_log_group"></a> [final\_exclude\_from\_application\_log\_group](#output\_final\_exclude\_from\_application\_log\_group) | The final list of log files to exclude from the application log group. |
| <a name="output_final_include_in_platform_log_group"></a> [final\_include\_in\_platform\_log\_group](#output\_final\_include\_in\_platform\_log\_group) | The final list of log files to include in the platform log group. |
| <a name="output_finale_k8s_common_labels"></a> [finale\_k8s\_common\_labels](#output\_finale\_k8s\_common\_labels) | The final list of common labels to apply to the Kubernetes resources. |

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_with_oidc_for_fluent_bit"></a> [iam\_assumable\_role\_with\_oidc\_for\_fluent\_bit](#module\_iam\_assumable\_role\_with\_oidc\_for\_fluent\_bit) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> 5.0 |


<!-- END_TF_DOCS -->
