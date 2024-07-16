locals {
  environment = {
    domain          = local.organization.domain
    organization_id = local.organization.org_id
  }

  organization     = data.terraform_remote_state.bootstrap.outputs.organization
  folders          = data.terraform_remote_state.bootstrap.outputs.folders
  projects         = data.terraform_remote_state.bootstrap.outputs.projects
  service_accounts = data.terraform_remote_state.bootstrap.outputs.service_accounts
  location         = data.terraform_remote_state.bootstrap.outputs.location

  prj_dev_tenant_1_services = [
    "pubsub.googleapis.com",
    "artifactregistry.googleapis.com",
    "storage.googleapis.com",
    "cloudfunctions.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com"
  ]

   prj_dev_tenant_2_services = [
    "pubsub.googleapis.com",
    "artifactregistry.googleapis.com",
    "storage.googleapis.com",
    "cloudfunctions.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com"
  ]

  deletion_protection = false

  substitutions = {
    kms_key_prj_tenant_1         = module.prj_tenant_1_kms_key.key_id
    kms_key_prj_tenant_2         = module.prj_tenant_2_kms_key.key_id
    service_account              = module.service_account.email
  }

  cluster_files = fileset("${path.module}/config/clusters", "*.yaml")
  cluster_configs = {
    for filename in local.cluster_files : replace(filename, ".yaml", "") => yamldecode(templatefile("${path.module}/config/clusters/${filename}", local.substitutions))
  }
}

