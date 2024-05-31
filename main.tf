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
}
