resource "google_sql_database_instance" "instance" {
  name = var.name
  database_version = var.database_version
  region = var.region

  settings {
    tier = "db-g1-small"
    ip_configuration {
      ipv4_enabled = true
    }
  }
}

resource "google_sql_user" "users" {
  name     = "postgres"
  instance = google_sql_database_instance.instance.name
  password = "postgres"
  depends_on = [google_sql_database_instance.instance]
}
