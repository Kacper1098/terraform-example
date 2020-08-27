output "cluster-endpoint" {
  value = google_container_cluster.cluster.endpoint
}

output "cluster-certificate" {
  value = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
}
