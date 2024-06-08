module "cluster" {
  for_each = local.cluster_configs
  source   = "github.com/lab-gke-se/modules//gke/cluster?ref=feature/gke-module"

  project                           = local.projects.prj_dev_tenant_1.project_id
  name                              = each.value.name
  autopilot                         = try(each.value.autopilot.enabled, false)
  deletion_protection               = local.deletion_protection
  location                          = each.value.location
  node_locations                    = each.value.locations
  network                           = each.value.network
  subnetwork                        = each.value.subnetwork
  ip_allocation_policy              = each.value.ipAllocationPolicy
  cluster_autoscaling               = each.value.autoscaling
  release_channel                   = each.value.releaseChannel.channel
  kubernetes_version                = "latest"
  addons_config                     = each.value.addonsConfig
  private_cluster_config            = each.value.privateClusterConfig
  master_authorized_networks_config = each.value.masterAuthorizedNetworksConfig
  database_encryption               = each.value.databaseEncryption
  maintenance_policy                = each.value.maintenancePolicy
  logging_config                    = each.value.loggingConfig
}
