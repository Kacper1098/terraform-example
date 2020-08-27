resource "google_container_cluster" "cluster" {
  name = var.name
  location = var.location
  remove_default_node_pool = true
  initial_node_count = 1
}

resource "google_container_node_pool" "node-pool" {
  name = "default-node-pool"
  cluster = google_container_cluster.cluster.name
  location = var.location
  node_count = 1

  node_config {
    preemptible = true
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
