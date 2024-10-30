module "firewall" {
  source   = "github.com/lab-gke-se/modules//compute/firewall/rule?ref=0.0.4"
  for_each = try(local.config.firewalls, [])

  project           = local.projects.prj_dev_tenant_1.project_id
  name              = each.value.name
  network           = each.value.network
  description       = try(each.value.description, null)
  priority          = try(each.value.priority, null)
  direction         = try(each.value.direction, null)
  disabled          = try(each.value.disabled, null)
  logConfig         = try(each.value.logConfig, null)
  sourceRanges      = try(each.value.sourceRanges, null)
  destinationRanges = try(each.value.destinationRanges, null)
  allowed           = try(each.value.allowed, null)
  denied            = try(each.value.denied, null)
}

module "router" {
  source   = "github.com/lab-gke-se/modules//compute/router?ref=0.0.4"
  for_each = try(local.config.routers, [])

  project                     = local.projects.prj_dev_tenant_1.project_id
  name                        = each.value.name
  region                      = each.value.region
  network                     = each.value.network
  description                 = try(each.value.description, null)
  encryptedInterconnectRouter = try(each.value.encryptedInterconnectRouter, null)
  bgp                         = try(each.value.bgp, null)
}

moved {
  from = google_compute_firewall.allow_ingress
  to   = module.firewall["dev-tenant-1-ai-iap"].google_compute_firewall.rule
}

moved {
  from = google_compute_router.egress_router
  to   = module.router["egress-router"].google_compute_router.router
}
