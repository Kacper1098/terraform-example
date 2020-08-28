terraform {
  backend "gcs" {
    bucket = "tfstate-kacper"
  }
}
