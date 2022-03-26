terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.15.0"
    }
  }
}

provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  credentials = "../credentials/key.json"
}

resource "google_compute_network" "myvpc" {
  name                    = var.vpc_name
  project                 = var.gcp_project
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subne1" {
  ip_cidr_range = "value"
  name          = "value"
  network       = "value"

}
