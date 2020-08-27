resource "random_id" "db_name_suffix" {
  byte_length = 4
}

provider "google" {
  version = "3.36.0"
  project = var.project_id
  region = var.region
  credentials = file(var.credentials)
}

data "google_client_config" "provider" {}

module "cluster" {
  source = "./cluster" //ścieżka do folderu w którym znajdują się pliki danego modułu
  name = "terraform-cluster"
  location = var.region //
}

module "sql" {
  source = "./sql"
  database_version = "POSTGRES_12"
  name = "terraform-sql-instance-${random_id.db_name_suffix.hex}"
  region = var.region
}

provider "kubernetes" {
  load_config_file = false
  host = "https://${module.cluster.cluster-endpoint}"

  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(module.cluster.cluster-certificate)
}

module "app" {
  source = "./app"
  credentials = var.credentials
  project_id = var.project_id
  region = var.region
  sql-instance-name = module.sql.sql-instance-name
  sql-database-name = "app-database"
  depends_on = [module.cluster, module.sql]
}
