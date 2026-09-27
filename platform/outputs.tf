output "aws_load_balancer_controller_release_name" {
  description = "Helm release name"
  value       = helm_release.aws_load_balancer_controller.name
}

output "aws_load_balancer_controller_namespace" {
  description = "Kubernetes namespace"
  value       = helm_release.aws_load_balancer_controller.namespace
}

output "aws_load_balancer_controller_chart_version" {
  description = "Installed Helm chart version"
  value       = helm_release.aws_load_balancer_controller.chart
}

output "aws_load_balancer_controller_status" {
  description = "Helm release status"
  value       = helm_release.aws_load_balancer_controller.status
}