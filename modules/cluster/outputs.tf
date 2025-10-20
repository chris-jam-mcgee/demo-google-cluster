output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Endpoint for GKE master"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_master_version" {
  description = "Current master kubernetes version"
  value       = google_container_cluster.primary.master_version
}

output "cluster_location" {
  description = "Location of the GKE cluster"
  value       = google_container_cluster.primary.location
}

output "node_pool_name" {
  description = "Name of the node pool"
  value       = google_container_node_pool.primary_nodes.name
}


output "cluster_ca_certificate" {
  description = "Cluster CA certificate (base64 encoded)"
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  sensitive   = true
}