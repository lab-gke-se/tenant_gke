module "cluster" {
  for_each = local.cluster_configs
  source   = "github.com/lab-gke-se/modules//gke/cluster?ref=feature%2Fgke-standard-cluster"
  # source   = "../modules/gke/cluster"

  project                        = local.projects.prj_dev_tenant_1.project_id
  name                           = each.value.name
  addonsConfig                   = each.value.addonsConfig
  autopilot                      = each.value.autopilot
  autoscaling                    = each.value.autoscaling
  binaryAuthorization            = try(each.value.binaryAuthorization, null)
  clusterIpv4Cidr                = try(each.value.clusterIpv4Cidr, null)
  currentMasterVersion           = try(each.value.currentMasterVersion, null)
  currentNodeVersion             = try(each.value.currentNodeVersion, null)
  databaseEncryption             = each.value.databaseEncryption
  defaultMaxPodsConstraint       = try(each.value.defaultMaxPodsConstraint, null)
  initialClusterVersion          = try(each.value.initialClusterVersion, null)
  ipAllocationPolicy             = each.value.ipAllocationPolicy
  location                       = each.value.location
  locations                      = each.value.locations
  loggingConfig                  = each.value.loggingConfig
  loggingService                 = each.value.loggingService
  maintenancePolicy              = each.value.maintenancePolicy
  masterAuth                     = try(each.value.masterAuth, null)
  masterAuthorizedNetworksConfig = each.value.masterAuthorizedNetworksConfig
  monitoringConfig               = each.value.monitoringConfig
  monitoringService              = each.value.monitoringService
  network                        = each.value.network
  networkConfig                  = try(each.value.networkConfig, null)
  nodeConfig                     = try(each.value.nodeConfig, null)
  nodePoolDefaults               = try(each.value.nodePoolDefaults, null)
  notificationConfig             = try(each.value.notificationConfig, null)
  privateClusterConfig           = each.value.privateClusterConfig
  releaseChannel                 = try(each.value.releaseChannel, null)
  securityPostureConfig          = try(each.value.securityPostureConfig, null)
  shieldedNodes                  = try(each.value.shieldedNodes, null)
  subnetwork                     = each.value.subnetwork
  verticalPodAutoscaling         = each.value.verticalPodAutoscaling
  workloadIdentityConfig         = try(each.value.workloadIdentityConfig, null)

  deletion_protection = local.deletion_protection
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

