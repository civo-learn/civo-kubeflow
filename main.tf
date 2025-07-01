resource "civo_kubernetes_cluster" "cluster" {
  name = var.cluster_name

  # Connect to the network & firewall
  firewall_id = civo_firewall.firewall.id
  network_id  = civo_network.network.id

  # Cluster type must be talos for GPU support
  cluster_type = "talos"

  # attach one 
  pools {
    size       = var.cluster_node_size
    node_count = var.cluster_node_count
  }

  # specify a timeout for the cluster creation
  timeouts {
    create = "10m"
  }
}

# Create a local file with the kubeconfig
resource "local_file" "cluster-config" {
  content              = civo_kubernetes_cluster.cluster.kubeconfig
  filename             = "${path.module}/kubeconfig"
  file_permission      = "0600"
  directory_permission = "0755"
}

# Create a default firewall
# Add your own secure values here before going to production
resource "civo_firewall" "firewall" {
  name                 = "${var.cluster_name}-firewall"
  network_id           = civo_network.network.id
  create_default_rules = true
}

resource "civo_network" "network" {
  label = "${var.cluster_name}-network"
}

resource "helm_release" "argo_cd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.3" # Latest as of June 2025

  values = [
    file("argocd-values.yaml") # Optional overrides
  ]
}

# Needed to combat the issues using deployKF on Talos
resource "helm_release" "kyverno" {
  depends_on       = [helm_release.argo_cd]
  name             = "kyverno"
  namespace        = "kyverno-labeller"
  repository       = "https://kyverno.github.io/kyverno/"
  chart            = "kyverno"
  version          = "2.6.3"
  create_namespace = true
}
