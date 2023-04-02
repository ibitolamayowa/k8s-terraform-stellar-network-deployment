module "gcp_cluster" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"

  project_id = var.project_id
  name_suffix = var.cluster_name_suffix
  region = var.region
  zones = var.zones
  network = var.network
  subnetwork = var.subnetwork
  ip_range_pods = var.ip_range_pods
  ip_range_services = var.ip_range_services
  enable_private_endpoint = true
  enable_private_nodes = true
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  node_pool = [
    {
      name = "default"
      machine_type = "n1-standard-2"
      disk_size_gb = 100
      disk_type = "pd-standard"
      min_count = 1
      max_count = 3
      preemptible = false
      autoscaling = true
      max_node_count = 5
      min_node_count = 1
      initial_node_count = 1
      node_labels = {
        "node-pool" = "default"
      }
      node_taints = [
        {
          key = "dedicated"
          value = "default"
          effect = "NoSchedule"
        }
      ]
      management = {
        auto_repair = true
        auto_upgrade = true
        upgrade_options = {
          auto_upgrade_start_time = "03:00"
        }
      }
      node_config = {
        oauth_scopes = [
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/compute"
        ]
      }
      workload_metadata_config = {
        node_metadata = "GKE_METADATA_SERVER"
        mode = "GKE_METADATA_SERVER"
      }
      service_account = {
        scopes = [
          "https://www.googleapis.com/auth/cloud-platform",
          "https://www.googleapis.com/auth/compute"
        ]
      }
      upgrade_settings = {
        max_surge = 1
        max_unavailable = 0
      }
    }
  ]
}

module "kubernetes_namespace" {
  source = "terraform-kubernetes-modules/namespace/kubernetes"

  metadata = {
    name = "stellar"
  }

  labels = {
    env = "production"
  }
}

module "kubernetes_secret" {
  source = "terraform-kubernetes-modules/secret/kubernetes"

  metadata = {
    name      = "stellar-secrets"
    namespace = module.kubernetes_namespace.metadata.name
  }

  data = {
    "database-url" = "c29tZS1kYXRhYmFzZS11cmw="
  }
}

module "stellar_network" {
  source = "./modules/stellar-network"

  core_service_name_prefix = "stellar-core"
  horizon_service_name_prefix = "stellar-horizon"
  namespace_name = module.kubernetes_namespace.metadata.name
  database_url_secret_name = module.kubernetes_secret.metadata.name
}
