locals {
  # TODO
  timeouts = {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}

module "cluster" {
  for_each = local.config.clusters
  source   = "github.com/lab-gke-se/modules//container/cluster?ref=0.0.4"
  # source = "../modules//container/cluster"

  # Terraform variables
  project                  = local.projects.prj_dev_tenant_1.project_id
  deletion_protection      = local.deletion_protection
  remove_default_node_pool = true
  timeouts                 = local.timeouts

  # GKE Variables
  name                      = each.value.name
  addonsConfig              = try(each.value.addonsConfig, null)
  authenticatorGroupsConfig = try(each.value.authenticatorGroupsConfig, null)
  autopilot                 = try(each.value.autopilot, null)
  autoscaling               = try(each.value.autoscaling, null)
  binaryAuthorization       = try(each.value.binaryAuthorization, null)
  clusterIpv4Cidr           = try(each.value.clusterIpv4Cidr, null)
  confidentialNodes         = try(each.value.confidentialNodes, null)
  costManagementConfig      = try(each.value.costManagementConfig, null)
  currentMasterVersion      = try(each.value.currentMasterVersion, null)
  currentNodeVersion        = try(each.value.currentNodeVersion, null)
  databaseEncryption        = try(each.value.databaseEncryption, null)
  defaultMaxPodsConstraint  = try(each.value.defaultMaxPodsConstraint, null)
  # description                    = try(each.value.description, null) - leave for now
  enableKubernetesAlpha          = try(each.value.enableKubernetesAlpha, null)
  enableK8sBetaApis              = try(each.value.enableK8sBetaApis, null)
  enableTpu                      = try(each.value.enableTpu, null)
  fleet                          = try(each.value.fleet, null)
  identityServiceConfig          = try(each.value.identityServiceConfig, null)
  initialClusterVersion          = try(each.value.initialClusterVersion, null)
  initialNodeCount               = try(each.value.initialNodeCount, null)
  ipAllocationPolicy             = try(each.value.ipAllocationPolicy, null)
  legacyAbac                     = try(each.value.legacyAbac, null)
  location                       = try(each.value.location, null)
  locations                      = try(each.value.locations, null)
  loggingConfig                  = try(each.value.loggingConfig, null)
  loggingService                 = try(each.value.loggingService, null)
  maintenancePolicy              = try(each.value.maintenancePolicy, null)
  masterAuth                     = try(each.value.masterAuth, null)
  masterAuthorizedNetworksConfig = try(each.value.masterAuthorizedNetworksConfig, null)
  meshCertificates               = try(each.value.meshCertificates, null)
  monitoringConfig               = try(each.value.monitoringConfig, null)
  monitoringService              = try(each.value.monitoringService, null)
  network                        = try(each.value.network, null)
  networkConfig                  = try(each.value.networkConfig, null)
  networkPolicy                  = try(each.value.networkPolicy, null)
  nodeConfig                     = try(each.value.nodeConfig, null)
  nodePoolAutoConfig             = try(each.value.nodePoolAutoConfig, null)
  nodePoolDefaults               = try(each.value.nodePoolDefaults, null)
  notificationConfig             = try(each.value.notificationConfig, null)
  privateClusterConfig           = try(each.value.privateClusterConfig, null)
  releaseChannel                 = try(each.value.releaseChannel, null)
  resourceLabels                 = try(each.value.resourceLabels, null)
  resourceUsageExportConfig      = try(each.value.resourceUsageExportConfig, null)
  securityPostureConfig          = try(each.value.securityPostureConfig, null)
  shieldedNodes                  = try(each.value.shieldedNodes, null)
  subnetwork                     = try(each.value.subnetwork, null)
  verticalPodAutoscaling         = try(each.value.verticalPodAutoscaling, null)
  workloadIdentityConfig         = try(each.value.workloadIdentityConfig, null)
}

locals {
  cluster_node_pools = flatten([
    for cluster_key, cluster in local.config.clusters : [
      for nodePool in try(cluster.nodePools, []) : [
        merge({
          cluster_key      = try(cluster_key, null)
          cluster_location = try(cluster.location, null)
          },
          nodePool
        )
      ]
    ] if try(cluster.autopilot.enabled, false) != true
  ])
}

module "node_pool" {
  for_each = { for cluster_node_pool in local.cluster_node_pools : "${cluster_node_pool.cluster_key}/${cluster_node_pool.name}" => cluster_node_pool }
  source   = "github.com/lab-gke-se/modules//container/node_pool?ref=0.0.4"
  # source = "../modules//container/node_pool"

  # Terraform / cluster variables
  project  = local.projects.prj_dev_tenant_1.project_id
  cluster  = module.cluster[each.value.cluster_key].name
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

moved {
  from = module.cluster["autopilot_public_us-central1"].google_container_cluster.primary
  to   = module.cluster["autopilot_public_us-central1"].google_container_cluster.cluster
}

moved {
  from = module.cluster["private"].google_container_cluster.primary
  to   = module.cluster["private"].google_container_cluster.cluster
}

moved {
  from = module.cluster["private_1"].google_container_cluster.primary
  to   = module.cluster["private_1"].google_container_cluster.cluster
}

moved {
  from = module.cluster["public"].google_container_cluster.primary
  to   = module.cluster["public"].google_container_cluster.cluster
}
