output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = module.gke_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for GKE master"
  value       = module.gke_cluster.cluster_endpoint
  sensitive   = true
}

output "cluster_master_version" {
  description = "Current master kubernetes version"
  value       = module.gke_cluster.cluster_master_version
}

output "cluster_location" {
  description = "Location of the GKE cluster"
  value       = module.gke_cluster.cluster_location
}
