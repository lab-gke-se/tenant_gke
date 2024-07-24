# Temp
module "cluster" {
  for_each = local.cluster_configs
  source   = "github.com/lab-gke-se/modules//gke/cluster?ref=main"

  project                           = local.projects.prj_dev_tenant_1.project_id
  name                              = each.value.name
  autopilot                         = try(each.value.autopilot.enabled, false)
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
  deletion_protection               = local.deletion_protection
}

resource "local_file" "containerd_config" {
  for_each = { for name, config in local.cluster_configs : name => config if try(config.nodePoolDefaults.nodeConfigDefaults.containerdConfig.privateRegistryAccessConfig, null) != null }

  content  = yamlencode(each.value.nodePoolDefaults.nodeConfigDefaults.containerdConfig)
  filename = "${path.module}/config/clusters/containerd-config/${each.value.name}.yaml"
}

resource "null_resource" "run_command" {
  for_each = { for name, config in local.cluster_configs : name => config if try(config.nodePoolDefaults.nodeConfigDefaults.containerdConfig.privateRegistryAccessConfig, null) != null }

  depends_on = [module.cluster]

  provisioner "local-exec" {
    when    = create
    command = <<-EOT
      gcloud container clusters update ${each.value.name} --location=${each.value.location} --containerd-config-from-file="${local_file.containerd_config[each.key].filename}"    
    EOT
  }

}

