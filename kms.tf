module "keyring" {
  source   = "../modules/kms/keyring"
  for_each = try(local.keyrings, {})

  name = each.value.name
}

module "key" {
  source   = "../modules/kms/key"
  for_each = try(local.kmskeys, {})

  name                          = each.value.name
  purpose                       = try(each.value.purpose, null)
  versionTemplate               = try(each.value.versionTemplate, null)
  labels                        = try(each.value.labels, null)
  importOnly                    = try(each.value.importOnly, null)
  destroyScheduledDuration      = try(each.value.destroyScheduledDuration, null)
  cryptoKeyBackend              = try(each.value.cryptoKeyBackend, null)
  keyAccessJustificationsPolicy = try(each.value.keyAccessJustificationsPolicy, null)
  rotationPeriod                = try(each.value.rotationPeriod, null)
  nextRotationTime              = try(each.value.nextRotationTime, null)

  depends_on = [module.keyring]
}

module "key_iam" {
  source   = "../modules/kms/iam"
  for_each = try(module.key, {})

  key_id   = each.value.key_id
  services = local.services
}

moved {
  from = module.prj_tenant_1_kms_key_ring.google_kms_key_ring.key_ring
  to   = module.keyring["LAB-GKE-SE-gke-key-ring-uudp"].google_kms_key_ring.key_ring
}

moved {
  from = module.prj_tenant_2_kms_key_ring.google_kms_key_ring.key_ring
  to   = module.keyring["LAB-GKE-SE-gke-key-ring-npkh"].google_kms_key_ring.key_ring
}

moved {
  from = module.prj_tenant_1_kms_key.google_kms_crypto_key.dev_key[0]
  to   = module.key["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].google_kms_crypto_key.key
}

moved {
  from = module.prj_tenant_2_kms_key.google_kms_crypto_key.dev_key[0]
  to   = module.key["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].google_kms_crypto_key.key
}

moved {
  from = module.prj_tenant_1_kms_key.google_kms_crypto_key_iam_binding.decrypters
  to   = module.key_iam["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].google_kms_crypto_key_iam_binding.decrypters
}

moved {
  from = module.prj_tenant_1_kms_key.google_kms_crypto_key_iam_binding.encrypters
  to   = module.key_iam["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].google_kms_crypto_key_iam_binding.encrypters
}

moved {
  from = module.prj_tenant_2_kms_key.google_kms_crypto_key_iam_binding.decrypters
  to   = module.key_iam["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].google_kms_crypto_key_iam_binding.decrypters
}

moved {
  from = module.prj_tenant_2_kms_key.google_kms_crypto_key_iam_binding.encrypters
  to   = module.key_iam["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].google_kms_crypto_key_iam_binding.encrypters
}

moved {
  from = module.prj_tenant_2_kms_key.module.service_identity["artifactregistry.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].module.service_identity["artifactregistry.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_2_kms_key.module.service_identity["cloudfunctions.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].module.service_identity["cloudfunctions.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_2_kms_key.module.service_identity["container.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].module.service_identity["container.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_2_kms_key.module.service_identity["pubsub.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].module.service_identity["pubsub.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_2_kms_key.module.service_identity["secretmanager.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].module.service_identity["secretmanager.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_1_kms_key.module.service_identity["artifactregistry.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].module.service_identity["artifactregistry.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_1_kms_key.module.service_identity["cloudfunctions.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].module.service_identity["cloudfunctions.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_1_kms_key.module.service_identity["container.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].module.service_identity["container.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_1_kms_key.module.service_identity["pubsub.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].module.service_identity["pubsub.googleapis.com"].google_project_service_identity.service_identity
}

moved {
  from = module.prj_tenant_1_kms_key.module.service_identity["secretmanager.googleapis.com"].google_project_service_identity.service_identity
  to   = module.key_iam["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].module.service_identity["secretmanager.googleapis.com"].google_project_service_identity.service_identity
}

# module "prj_tenant_1_kms_key_ring" {
#   source = "github.com/lab-gke-se/modules//kms/key_ring?ref=main"

#   name     = "${local.projects["prj_dev_tenant_1"].name}-gke-key-ring"
#   project  = local.projects["prj_dev_tenant_1"].project_id
#   location = "us-east4"
# }

# module "prj_tenant_1_kms_key" {
#   source = "github.com/lab-gke-se/modules//kms/key?ref=main"

#   name     = "${local.projects["prj_dev_tenant_1"].name}-gke-key"
#   project  = local.projects["prj_dev_tenant_1"].project_id
#   key_ring = module.prj_tenant_1_kms_key_ring.id
#   services = local.prj_dev_tenant_1_services
# }

# module "prj_tenant_2_kms_key_ring" {
#   source = "github.com/lab-gke-se/modules//kms/key_ring?ref=main"

#   name     = "${local.projects["prj_dev_tenant_1"].name}-gke-key-ring"
#   project  = local.projects["prj_dev_tenant_1"].project_id
#   location = "us-central1"
# }

# module "prj_tenant_2_kms_key" {
#   source = "github.com/lab-gke-se/modules//kms/key?ref=main"

#   name     = "${local.projects["prj_dev_tenant_1"].name}-gke-key"
#   project  = local.projects["prj_dev_tenant_1"].project_id
#   key_ring = module.prj_tenant_2_kms_key_ring.id
#   services = local.prj_dev_tenant_1_services
# }
