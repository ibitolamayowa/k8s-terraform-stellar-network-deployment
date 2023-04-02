variable "cluster_name" {
  description = "The name of the Kubernetes cluster to create"
  type        = string
  default     = "stellar-cluster"
}

variable "region" {
  description = "The region where the Kubernetes cluster should be created"
  type        = string
  default     = "us-central1"
}

variable "core_replicas" {
  description = "The number of replicas for the Stellar Core deployment"
  type        = number
  default     = 1
}

variable "horizon_replicas" {
  description = "The number of replicas for the Horizon deployment"
  type        = number
  default     = 1
}
