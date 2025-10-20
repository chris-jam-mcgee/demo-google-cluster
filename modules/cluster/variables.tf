# Required Variables
variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "The location (region or zone) of the GKE cluster"
  type        = string
}

variable "environment" {
  description = "Environment name (prod, nonprod)"
  type        = string
}

# Network Variables
variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
  default     = ""
}

# Cluster Configuration
variable "enable_network_policy" {
  description = "Enable network policy for the cluster"
  type        = bool
  default     = true
}

variable "enable_shielded_nodes" {
  description = "Enable shielded nodes for the cluster"
  type        = bool
  default     = true
}

# DNS Configuration
variable "cluster_dns" {
  description = "DNS provider for the cluster (CLOUD_DNS or PLATFORM_DEFAULT)"
  type        = string
  default     = "CLOUD_DNS"
}

variable "cluster_dns_scope" {
  description = "DNS scope (CLUSTER_SCOPE or VPC_SCOPE)"
  type        = string
  default     = "CLUSTER_SCOPE"
}

variable "cluster_dns_domain" {
  description = "DNS domain for the cluster"
  type        = string
  default     = "cluster.local"
}

variable "authorized_networks" {
  description = "List of master authorized networks"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = null
}

# Private Cluster Configuration
variable "enable_private_cluster" {
  description = "Enable private cluster"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for the cluster master"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for the master network"
  type        = string
  default     = "10.0.0.0/28"
}

# Node Pool Configuration
variable "node_count" {
  description = "Number of nodes in the node pool"
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "Machine type for cluster nodes"
  type        = string
  default     = "e2-medium"
}

variable "preemptible" {
  description = "Use preemptible nodes"
  type        = bool
  default     = false
}

variable "service_account" {
  description = "Service account for cluster nodes"
  type        = string
  default     = null
}

variable "node_labels" {
  description = "Labels to apply to nodes"
  type        = map(string)
  default     = {}
}

variable "node_tags" {
  description = "Tags to apply to nodes"
  type        = list(string)
  default     = []
}

# Shielded Instance Configuration
variable "enable_secure_boot" {
  description = "Enable secure boot for nodes"
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring for nodes"
  type        = bool
  default     = true
}

# Autoscaling Configuration
variable "enable_autoscaling" {
  description = "Enable autoscaling for the node pool"
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Minimum number of nodes in the pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in the pool"
  type        = number
  default     = 10
}

# Node Management
variable "auto_repair" {
  description = "Enable auto repair for nodes"
  type        = bool
  default     = true
}

variable "auto_upgrade" {
  description = "Enable auto upgrade for nodes"
  type        = bool
  default     = true
}

# Storage Configuration
variable "bucket_location" {
  description = "Location for the storage bucket"
  type        = string
  default     = "US"
}