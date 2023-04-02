variable "name_suffix" {
  description = "Suffix to add to the Stellar Core deployment name"
}

variable "namespace_name" {
  description = "Name of the Kubernetes namespace for Stellar"
}

variable "database_url_secret_name" {
  description = "Name of the Kubernetes secret that stores the database URL"
}