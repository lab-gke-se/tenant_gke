resource "google_compute_firewall" "allow_ingress" {
  name          = "dev-tenant-1-ai-iap"
  description   = "IAP ingress to ssh"
  direction     = "INGRESS"
  project       = local.projects.prj_dev_tenant_1.project_id
  network       = local.cluster_configs["private"].network
  source_ranges = ["35.235.240.0/20"]
  disabled      = false
  priority      = 1000
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_router" "egress_router" {
  name    = "egress-router"
  project = local.projects.prj_dev_tenant_1.project_id
  network = local.cluster_configs["private"].network
  region  = "us-east4"
}

# resource "google_compute_router_nat" "nat" {
#   name                               = "nat"
#   project                            = local.projects.prj_dev_tenant_1.project_id
#   router                             = google_compute_router.egress_router.name
#   region                             = google_compute_router.egress_router.region
#   nat_ip_allocate_option             = "AUTO_ONLY"
#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
# }

resource "google_compute_instance" "bastion" {

  project      = local.projects.prj_dev_tenant_1.project_id
  name         = "bastion"
  zone         = "us-east4-a"
  machine_type = "e2-micro"

  network_interface {
    network            = local.cluster_configs["private"].network
    subnetwork         = local.cluster_configs["private"].subnetwork
    subnetwork_project = local.projects.prj_dev_tenant_1.project_id
    stack_type         = "IPV4_ONLY"
  }

  boot_disk {
    source            = ""
    auto_delete       = true
    kms_key_self_link = ""
    device_name       = "book-disk-glr-1"
    mode              = "READ_WRITE"
    initialize_params {
      image  = "debian-cloud/debian-11"
      size   = 11
      type   = "pd-balanced"
      labels = { type = "boot-disk" }
    }
  }

  #   service_account {
  #     email  = module.service_account.email
  #     scopes = ["cloud-platform"]
  #   }

  #   enable_display      = false
  #   resource_policies   = []
  #   description         = "Compute for Backstage"
  #   desired_status      = "RUNNING"
  #   deletion_protection = false
  #   hostname            = ""

  #   shielded_instance_config {
  #     enable_secure_boot          = true
  #     enable_vtpm                 = true
  #     enable_integrity_monitoring = true
  #   }

  depends_on = [google_compute_firewall.allow_ingress]
}
