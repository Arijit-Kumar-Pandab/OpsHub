# ---------------------------------------------------------
# Vault Kubernetes Authentication
# ---------------------------------------------------------

resource "vault_auth_backend" "kubernetes" {
  type        = "kubernetes"
  path        = "kubernetes"
  description = "Kubernetes authentication for OpsHub workloads"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend = vault_auth_backend.kubernetes.path

  kubernetes_host = data.aws_eks_cluster.opshub.endpoint

  use_annotations_as_alias_metadata = true

  # Vault runs inside Kubernetes, so we intentionally do not
  # provide token_reviewer_jwt or kubernetes_ca_cert here.
  #
  # Vault will use its own projected service-account token
  # and local CA certificate for TokenReview.
}