# resource "google_compute_firewall" "master_webhooks" {
#   name        = "gke-public-webhooks"
#   description = "Managed by terraform gke module: Allow master to hit pods for admission controllers/webhooks"
#   project     = local.projects.prj_dev_tenant_1.project_id
#   network     = local.cluster_configs["private"].network
#   priority    = 1000
#   direction   = "INGRESS"

#   source_ranges = [local.cluster_configs["private"].endpoint / 32]
#   source_tags   = []
#   target_tags   = ["gke-"] // Do we need to set the tags?

#   allow {
#     protocol = "tcp"
#     ports    = ["8443", "9443", "15017"]
#   }

#   depends_on = [
#     google_container_cluster.primary,
#   ]

# }
