output "final_k8s_common_labels" {
  description = "The final list of common labels to apply to the Kubernetes resources."
  value       = local.k8s_common_labels
}

output "final_exclude_from_application_log_group" {
  description = "The final list of log files to exclude from the application log group."
  value       = local.exclude_from_application_log_group
}

output "final_include_in_platform_log_group" {
  description = "The final list of log files to include in the platform log group."
  value       = local.include_in_platform_log_group
}
