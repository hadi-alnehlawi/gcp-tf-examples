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
  ip_cidr_range = var.ip_cidr_range
  name          = var.subnet1
  network       = google_compute_network.myvpc.id
}

resource "google_compute_firewall" "name" {
  name    = "myfirewall"
  network = google_compute_network.myvpc.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = [var.myip, var.gcpcloudip, "0.0.0.0/0"]
}

resource "google_compute_instance" "myvmw" {
  machine_type = var.gce_machine_type
  zone = var.gcp_zone
  name = "myvmw"
  boot_disk {
    initialize_params {
      image = "debian-9-stretch-v20220317"
      size = 20
    }
  }
  network_interface {
    network = google_compute_network.myvpc.id
    subnetwork = google_compute_subnetwork.subne1.id
  }
  desired_status = "TERMINATED"

}
