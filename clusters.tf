module "cluster" {
  for_each = local.cluster_configs
  source   = "github.com/lab-gke-se/modules//gke/cluster?ref=feature%2Fstandard-cluster"
  # source = "../modules/gke/cluster"

  project                        = local.projects.prj_dev_tenant_1.project_id
  name                           = each.value.name
  addonsConfig                   = try(each.value.addonsConfig, null)
  autopilot                      = try(each.value.autopilot, null)
  autoscaling                    = try(each.value.autoscaling, null)
  binaryAuthorization            = try(each.value.binaryAuthorization, null)
  clusterIpv4Cidr                = try(each.value.clusterIpv4Cidr, null)
  conditions                     = try(each.value.conditions, null)
  currentMasterVersion           = try(each.value.currentMasterVersion, null)
  currentNodeVersion             = try(each.value.currentNodeVersion, null)
  databaseEncryption             = try(each.value.databaseEncryption, null)
  defaultMaxPodsConstraint       = try(each.value.defaultMaxPodsConstraint, null)
  fleet                          = try(each.value.fleet, null)
  initialClusterVersion          = try(each.value.initialClusterVersion, null)
  ipAllocationPolicy             = try(each.value.ipAllocationPolicy, null)
  location                       = try(each.value.location, null)
  locations                      = try(each.value.locations, null)
  loggingConfig                  = try(each.value.loggingConfig, null)
  loggingService                 = try(each.value.loggingService, null)
  maintenancePolicy              = try(each.value.maintenancePolicy, null)
  masterAuth                     = try(each.value.masterAuth, null)
  masterAuthorizedNetworksConfig = try(each.value.masterAuthorizedNetworksConfig, null)
  monitoringConfig               = try(each.value.monitoringConfig, null)
  monitoringService              = try(each.value.monitoringService, null)
  network                        = try(each.value.network, null)
  networkConfig                  = try(each.value.networkConfig, null)
  nodeConfig                     = try(each.value.nodeConfig, null)
  nodePoolDefaults               = try(each.value.nodePoolDefaults, null)
  notificationConfig             = try(each.value.notificationConfig, null)
  privateClusterConfig           = try(each.value.privateClusterConfig, null)
  releaseChannel                 = try(each.value.releaseChannel, null)
  securityPostureConfig          = try(each.value.securityPostureConfig, null)
  shieldedNodes                  = try(each.value.shieldedNodes, null)
  subnetwork                     = try(each.value.subnetwork, null)
  verticalPodAutoscaling         = try(each.value.verticalPodAutoscaling, null)
  workloadIdentityConfig         = try(each.value.workloadIdentityConfig, null)

  deletion_protection = local.deletion_protection
}

locals {
  cluster_node_pools = flatten([
    for cluster in local.cluster_configs : [
      for nodePool in try(cluster.nodePools, []) : [
        merge({
          cluster_name     = try(cluster.name, null)
          cluster_location = try(cluster.location, null)
          },
          nodePool
        )
      ]
    ] if try(cluster.autopilot.enabled, false) != true
  ])
}

module "node_pool" {
  for_each = { for cluster_node_pool in local.cluster_node_pools : "${cluster_node_pool.cluster_name}/${cluster_node_pool.name}" => cluster_node_pool }
  source   = "github.com/lab-gke-se/modules//gke/node_pool?ref=feature%2Fstandard-cluster"
  # source   = "../modules/gke/node_pool"

  # Terraform / cluster variables
  project  = local.projects.prj_dev_tenant_1.project_id
  cluster  = each.value.cluster_name
  location = each.value.cluster_location

  # Node Pool variables
  name                   = each.value.name
  initialNodeCount       = try(each.value.initialNodeCount, null)
  config                 = try(each.value.config, null)
  locations              = try(each.value.locations, null)
  networkConfig          = try(each.value.networkConfig, null)
  nodeVersion            = try(each.value.version, null)
  autoscaling            = try(each.value.autoscaling, null)
  management             = try(each.value.management, null)
  maxPodsConstraint      = try(each.value.maxPodsConstraint, null)
  upgradeSettings        = try(each.value.upgradeSettings, null)
  placementPolicy        = try(each.value.placementPolicy, null)
  queuedProvisioning     = try(each.value.queuedProvisioning, null)
  bestEffortProvisioning = try(each.value.bestEffortProvisioning, null)
}



# Temporary until containerd supported by terraform
# resource "local_file" "containerd_config" {
#   for_each = { for name, config in local.cluster_configs : name => config if try(config.nodePoolDefaults.nodeConfigDefaults.containerdConfig.privateRegistryAccessConfig, null) != null }

#   content  = yamlencode(each.value.nodePoolDefaults.nodeConfigDefaults.containerdConfig)
#   filename = "${path.module}/config/clusters/containerd-config/${each.value.name}.yaml"
# }

# resource "null_resource" "run_command" {
#   for_each = { for name, config in local.cluster_configs : name => config if try(config.nodePoolDefaults.nodeConfigDefaults.containerdConfig.privateRegistryAccessConfig, null) != null }

#   depends_on = [module.cluster]

#   provisioner "local-exec" {
#     when    = create
#     command = <<-EOT
#       gcloud container clusters update ${each.value.name} --location=${each.value.location} --containerd-config-from-file="${local_file.containerd_config[each.key].filename}"    
#     EOT
#   }

# }

