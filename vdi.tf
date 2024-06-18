resource "google_compute_instance" "vdi" {

  project                   = local.projects.prj_dev_tenant_1.project_id
  name                      = "vdi"
  zone                      = "us-east4-a"
  machine_type              = "e2-standard-2"
  allow_stopping_for_update = true

  network_interface {
    network            = "projects/lab-gke-se/global/networks/onpremise"
    subnetwork         = "vdi"
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
