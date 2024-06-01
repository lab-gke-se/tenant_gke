resource "google_compute_firewall" "allow_ingress" {
  name          = "dev-tenant-1-ai-iap"
  description   = "IAP ingress to ssh"
  direction     = "INGRESS"
  network       = local.network_name
  project       = local.projects.prj_dev_tenant_1.project_id
  source_ranges = ["35.235.240.0/20"]
  disabled      = false
  priority      = 1000
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "bastion" {

  project      = local.projects.prj_dev_tenant_1.project_id
  name         = "bastion"
  zone         = "us-east4-a"
  machine_type = "e2-micro"

  network_interface {
    network            = local.network_name
    subnetwork         = local.cluster_private.subnet_name
    subnetwork_project = local.projects.prj_dev_tenant_1.project_id
    //    stack_type         = "IPV4_ONLY"

    //    access_config {
    //      nat_ip = google_compute_address.static.address
    //    }

    # access_config {
    #   nat_ip                 = lookup(var.external_ip_config, "nat_ip", null)
    #   public_ptr_domain_name = lookup(var.external_ip_config, "public_ptr_domain_name", null)
    #   network_tier           = lookup(var.external_ip_config, "network_tier", null)
    # }

    # dynamic "alias_ip_range" {
    #   for_each = var.enable_alias_ip_range == false ? [] : var.alias_ip_range_config
    #   content {
    #     ip_cidr_range         = lookup(alias_ip_range.value, "ip_cidr_range", null)
    #     subnetwork_range_name = lookup(alias_ip_range.value, "subnetwork_range_name", null)
    #   }
    # }
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

  #   allow_stopping_for_update = true
  #   metadata = {
  #     cluster-name           = "compute-backstage"
  #     block-protect-ssh-keys = true
  #   }
  #   can_ip_forward = false
  #   tags           = ["compute-backstage"]

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

  #   metadata_startup_script = <<-EOF
  #       set -x
  #       apt-get update --allow-releaseinfo-change
  #       apt-get install -y git-all curl make build-essential docker
  #       cd /root/
  #       curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - &&\
  #       apt-get install -y nodejs && \
  #       npm install -g yarn
  #       echo backstage | npx --yes @backstage/create-app@latest
  #       INTERNAL_IP=`ip addr show ens4 | grep -oP 'inet \K[\d.]+'`
  #       EXTERNAL_IP=`curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip`
  #       cd backstage
  #       sed -i "s/origin: http:\\/\\/localhost:3000/origin: http:\\/\\/*/g" app-config.yaml
  #       sed -i "s/localhost:3000/$${EXTERNAL_IP}:7007/g" app-config.yaml
  #       sed -i "s/localhost:7007/$${EXTERNAL_IP}:7007/g" app-config.yaml
  #       sed -i '/127.0.0.1/s/^[ \\t]*#/   /g' app-config.yaml
  #       sed -i "s/127.0.0.1/$${INTERNAL_IP}/g" app-config.yaml
  #       sed -i "s/csp:/csp:\n    upgrade-insecure-requests: false/g" app-config.yaml
  #       yarn install --frozen-lockfile
  #       yarn tsc
  #       yarn build:backend --config ../../app-config.yaml
  #       nohup yarn start-backend &
  #   EOF

  depends_on = [google_compute_firewall.allow_ingress]
}
