resource "kubernetes_deployment" "stellar_horizon" {
  metadata {
    name      = "stellar-horizon-${var.name_suffix}"
    namespace = var.namespace_name

    labels = {
      app = "stellar-horizon"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "stellar-horizon"
      }
    }

    template {
      metadata {
        labels = {
          app = "stellar-horizon"
        }
      }

      spec {
        container {
          name  = "stellar-horizon"
          image = "stellar/quickstart:latest"

          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = var.database_url_secret_name
                key  = "database-url"
              }
            }
          }

          ports {
            container_port = 8000
          }

          args = [
            "run",
            "--conf=/opt/stellar-horizon.cfg",
          ]

          volume_mount {
            name       = "stellar-horizon-config"
            mount_path = "/opt/stellar-horizon.cfg"
            sub_path   = "stellar-horizon.cfg"
          }
        }

        volume {
          name = "stellar-horizon-config"

          config_map {
            name = "stellar-horizon-config"
          }
        }
      }
    }
  }
}
