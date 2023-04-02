resource "kubernetes_deployment" "stellar_core" {
  metadata {
    name      = "stellar-core-${var.name_suffix}"
    namespace = var.namespace_name


    labels = {
      app = "stellar-core"
    }
  }

  spec {
    replicas = 1


    selector {
      match_labels = {
        app = "stellar-core"
      }
    }

    template {
      metadata {
        labels = {
          app = "stellar-core"
        }
      }

      spec {
        container {
          name  = "stellar-core"
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
            container_port = 11625
          }

          args = [
            "run",
            "--conf=/opt/stellar-core.cfg",
          ]

          volume_mount {
            name       = "stellar-core-config"
            mount_path = "/opt/stellar-core.cfg"
            sub_path   = "stellar-core.cfg"
          }
        }

        volume {
          name = "stellar-core-config"

          config_map {
            name = "stellar-core-config"
          }
        }
      }
    }
  }
}