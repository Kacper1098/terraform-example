resource "kubernetes_config_map" "app-config-map" {
  metadata {
    name = "app-config-map"
  }

  data = {
    SPRING_DATASOURCE_USERNAME = "postgres"
    SPRING_DATASOURCE_PASSWORD = "postgres"
    SPRING_DATASOURCE_URL = "jdbc:postgresql://localhost:5432/${var.sql-database-name}"
  }
}

resource "google_sql_database" "app-database" {
  instance = var.sql-instance-name
  name = var.sql-database-name
}

resource "kubernetes_service" "app-service" {
  metadata {
    name = "app-service"
  }
  spec {
    type = "NodePort"
    selector = {
      app = "app"
    }
    port {
      port = 80
      protocol = "TCP"
      target_port = 8080
    }
  }
}

resource "kubernetes_ingress" "app-ingress" {
  metadata {
    name = "app-ingress"
  }
  spec {
    backend {
      service_name = kubernetes_service.app-service.metadata[0].name
      service_port = kubernetes_service.app-service.spec[0].port[0].port
    }
  }
  depends_on = [kubernetes_service.app-service]
}

resource "kubernetes_secret" "credentials-secret" {
  metadata {
    name = "credentials-secret"
  }
  data = {
    "credentials" = file(var.credentials)
  }

}

resource "kubernetes_deployment" "app" {
  metadata {
    name = "app"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app"
      }
    }
    template {
      metadata {
        labels = {
          app = "app"
        }
      }
      spec {
        container {
          name = "app"
          image = "gcr.io/terraform-example-project/app:latest"
          env_from {
            config_map_ref {
              name = "app-config-map"
            }
          }
        }
        container {
          name = "cloud-sql-proxy"
          image = "gcr.io/cloudsql-docker/gce-proxy:1.17"
          command = [
            "/cloud_sql_proxy",
            "-instances=${var.project_id}:${var.region}:${var.sql-instance-name}=tcp:5432",
            "-credential_file=/secret/credentials.json"
          ]
          security_context {
            run_as_group = 2000
            run_as_non_root = true
            run_as_user = 1000
          }
          volume_mount {
            mount_path = "/secret"
            name = "credentials"
            read_only = true
          }
        }
        volume {
          name = "credentials"
          secret {
            secret_name = "credentials-secret"
            items {
              key = "credentials"
              path = "credentials.json"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_service.app-service, kubernetes_secret.credentials-secret,
                kubernetes_config_map.app-config-map, google_sql_database.app-database]
}
