module "instance" {
  source   = "../modules/compute/instance"
  for_each = try(local.config.instances, [])

  # allow_stopping_for_update = false
  # metadata_startup_script = ??

  project                         = local.projects.prj_dev_tenant_1.project_id
  name                            = each.value.name
  description                     = try(each.value.description, null)
  tags                            = try(each.value.tags, null)
  machineType                     = try(each.value.machineType, null)
  zone                            = try(each.value.zone, null)
  canIpForward                    = try(each.value.canIpForward, null)
  networkInterfaces               = try(each.value.networkInterfaces, null)
  disks                           = try(each.value.disks, null)
  metadata                        = try(each.value.metadata, null)
  serviceAccounts                 = try(each.value.serviceAccounts, null)
  scheduling                      = try(each.value.scheduling, null)
  instanceEncryptionKey           = try(each.value.instanceEncryptionKey, null)
  minCpuPlatform                  = try(each.value.minCpuPlatform, null)
  guestAccelerators               = try(each.value.guestAccelerators, null)
  startRestricted                 = try(each.value.startRestricted, null)
  deletionProtection              = try(each.value.deletionProtection, null)
  resourcePolicies                = try(each.value.resourcePolicies, null)
  sourceMachineImage              = try(each.value.sourceMachineImage, null)
  reservationAffinity             = try(each.value.reservationAffinity, null)
  hostname                        = try(each.value.hostname, null)
  displayDevice                   = try(each.value.displayDevice, null)
  shieldedInstanceConfig          = try(each.value.shieldedInstanceConfig, null)
  shieldedInstanceIntegrityPolicy = try(each.value.shieldedInstanceIntegrityPolicy, null)
  sourceMachineImageEncryptionKey = try(each.value.sourceMachineImageEncryptionKey, null)
  confidentialInstanceConfig      = try(each.value.confidentialInstanceConfig, null)
  privateIpv6GoogleAccess         = try(each.value.privateIpv6GoogleAccess, null)
  advancedMachineFeatures         = try(each.value.advancedMachineFeatures, null)
  resourceStatus                  = try(each.value.resourceStatus, null)
  networkPerformanceConfig        = try(each.value.networkPerformanceConfig, null)
  keyRevocationActionType         = try(each.value.keyRevocationActionType, null)
}

module "disk" {
  source   = "../modules/compute/disk"
  for_each = try(local.config.disks, [])

  project                      = local.projects.prj_dev_tenant_1.project_id
  name                         = each.value.name
  description                  = try(each.value.description, null)
  sizeGb                       = try(each.value.sizeGb, null)
  zone                         = try(each.value.zone, null)
  sourceSnapshot               = try(each.value.sourceSnapshot, null)
  sourceStorageObject          = try(each.value.sourceStorageObject, null)
  options                      = try(each.value.options, null)
  sourceImage                  = try(each.value.sourceImage, null)
  type                         = try(each.value.type, null)
  licenses                     = try(each.value.licenses, null)
  guestOsFeatures              = try(each.value.guestOsFeatures, null)
  users                        = try(each.value.users, null)
  diskEncryptionKey            = try(each.value.diskEncryptionKey, null)
  sourceImageEncryptionKey     = try(each.value.sourceImageEncryptionKey, null)
  sourceSnapshotEncryptionKey  = try(each.value.sourceSnapshotEncryptionKey, null)
  labels                       = try(each.value.labels, null)
  region                       = try(each.value.region, null)
  replicaZones                 = try(each.value.replicaZones, null)
  licenseCodes                 = try(each.value.licenseCodes, null)
  physicalBlockSizeBytes       = try(each.value.physicalBlockSizeBytes, null)
  resourcePolicies             = try(each.value.resourcePolicies, null)
  sourceDisk                   = try(each.value.sourceDisk, null)
  provisionedIops              = try(each.value.provisionedIops, null)
  provisionedThroughput        = try(each.value.provisionedThroughput, null)
  enableConfidentialCompute    = try(each.value.enableConfidentialCompute, null)
  sourceInstantSnapshot        = try(each.value.sourceInstantSnapshot, null)
  locationHint                 = try(each.value.locationHint, null)
  storagePool                  = try(each.value.storagePool, null)
  accessMode                   = try(each.value.accessMode, null)
  asyncPrimaryDisk             = try(each.value.asyncPrimaryDisk, null)
  asyncSecondaryDisks          = try(each.value.asyncSecondaryDisks, null)
  resourceStatus               = try(each.value.resourceStatus, null)
  sourceConsistencyGroupPolicy = try(each.value.sourceConsistencyGroupPolicy, null)
  architecture                 = try(each.value.architecture, null)
  params                       = try(each.value.params, null)
}
