terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.7"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Call the cluster module
module "gke_cluster" {
  source = "../../modules/cluster"

  project_id     = var.project_id
  cluster_name   = var.cluster_name
  location       = var.location
  environment    = var.environment
  
  # Network configuration
  network    = var.network
  subnetwork = var.subnetwork
  
  # Cluster security
  enable_network_policy = var.enable_network_policy
  enable_shielded_nodes = var.enable_shielded_nodes
  authorized_networks   = var.authorized_networks
  
  # DNS configuration for ArgoCD exposure
  cluster_dns        = var.cluster_dns
  cluster_dns_scope  = var.cluster_dns_scope
  cluster_dns_domain = var.cluster_dns_domain
  
  # Private cluster settings
  enable_private_cluster   = var.enable_private_cluster
  enable_private_endpoint  = var.enable_private_endpoint
  master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  
  # Node configuration
  node_count    = var.node_count
  machine_type  = var.machine_type
  preemptible   = var.preemptible
  node_labels   = var.node_labels
  node_tags     = var.node_tags
  
  # Shielded instance config
  enable_secure_boot          = var.enable_secure_boot
  enable_integrity_monitoring = var.enable_integrity_monitoring
  
  # Autoscaling
  enable_autoscaling = var.enable_autoscaling
  min_node_count     = var.min_node_count
  max_node_count     = var.max_node_count
  
  # Management
  auto_repair   = var.auto_repair
  auto_upgrade  = var.auto_upgrade
  
  # Storage
  bucket_location = var.bucket_location
}