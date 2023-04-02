variable "core_service_name_prefix" {
  description = "Prefix for the Stellar Core service name"
}

variable "horizon_service_name_prefix" {
  description = "Prefix for the Stellar Horizon service name"
}

variable "namespace_name" {
  description = "Name of the Kubernetes namespace to create for Stellar"
}

variable "database_url_secret_name" {
  description = "Name of the Kubernetes secret that stores the database URL"
}