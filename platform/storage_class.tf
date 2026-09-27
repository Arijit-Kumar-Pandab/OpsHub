resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"

  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  allow_volume_expansion = true

  parameters = {
    type                        = "gp3"
    encrypted                   = "true"
    "csi.storage.k8s.io/fstype" = "ext4"
  }
}