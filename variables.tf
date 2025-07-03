# # # # # # # # # # # # # 
# Cluster Configuration # 
# # # # # # # # # # # # # 

# The name of the cluster
variable "cluster_name" {
  type        = string
  default     = "kubeflow"
  description = "The name of the cluster to create"
}

# the GPU node instance to use for the cluster
variable "cluster_node_size" {
  type        = string
  default     = "g4p.kube.medium"
  description = "The size of the GPU node required for the cluster"
}

# the number of nodes to provision in the cluster
variable "cluster_node_count" {
  type        = number
  default     = "1"
  description = "The number of nodes to provision in the cluster"
}

variable "bash_path" {
  description = "Path to the Bash binary >= 4.4"
  type        = string
  default     = "/opt/homebrew/bin/bash" # Change this to your preferred default
}

# # # # # # # # # # # 
# Civo configuration # 
# # # # # # # # # # # 

# The Civo API token, this is set in terraform.tfvars
variable "civo_token" {}

# The Civo Region to deploy the cluster in
variable "region" {
  type        = string
  default     = "LON1"
  description = "The region to provision the cluster against"
}
