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

  services = [
    "pubsub.googleapis.com",
    "artifactregistry.googleapis.com",
    "storage.googleapis.com",
    "cloudfunctions.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com"
  ]

  deletion_protection = false

  substitutions = {
    kms_key_prj_tenant_1 = local.kmskeys["us-east4/lab-gke-se-gke-key-ring-uudp/LAB-GKE-SE-gke-key"].name
    kms_key_prj_tenant_2 = local.kmskeys["us-central1/lab-gke-se-gke-key-ring-npkh/LAB-GKE-SE-gke-key"].name
    service_account      = local.serviceaccounts["gke-cluster"].email
  }

  keyring_files        = fileset("${path.module}/config/kms/keyring", "*.yaml")
  key_files            = fileset("${path.module}/config/kms/key", "**/*.yaml")
  instance_files       = fileset("${path.module}/config/compute/instance", "*.yaml")
  disk_files           = fileset("${path.module}/config/compute/disk", "*.yaml")
  firewall_files       = fileset("${path.module}/config/compute/firewall", "*.yaml")
  router_files         = fileset("${path.module}/config/compute/router", "*.yaml")
  serviceaccount_files = fileset("${path.module}/config/iam/serviceaccount", "*.yaml")
  cluster_files        = fileset("${path.module}/config/container/clusters", "*.yaml")
  secret_files         = fileset("${path.module}/config/secretmanager/secrets", "*.yaml")
  bucket_files         = fileset("${path.module}/config/storage/buckets", "*.yaml")

  keyrings        = { for filename in local.keyring_files : replace(filename, ".yaml", "") => yamldecode(file("${path.module}/config/kms/keyring/${filename}")) }
  kmskeys         = { for filename in local.key_files : replace(filename, ".yaml", "") => yamldecode(file("${path.module}/config/kms/key/${filename}")) }
  serviceaccounts = { for filename in local.serviceaccount_files : replace(filename, ".yaml", "") => yamldecode(file("${path.module}/config/iam/serviceaccount/${filename}")) }
  secrets         = { for filename in local.secret_files : replace(filename, ".yaml", "") => yamldecode(file("${path.module}/config/secretmanager/secrets/${filename}")) }
  buckets         = { for filename in local.bucket_files : replace(filename, ".yaml", "") => yamldecode(file("${path.module}/config/storage/buckets/${filename}")) }

  config = {
    instances = { for filename in local.instance_files : replace(filename, ".yaml", "") => yamldecode(templatefile("${path.module}/config/compute/instance/${filename}", local.substitutions)) }
    disks     = { for filename in local.disk_files : replace(filename, ".yaml", "") => yamldecode(templatefile("${path.module}/config/compute/disk/${filename}", local.substitutions)) }
    firewalls = { for filename in local.firewall_files : replace(filename, ".yaml", "") => yamldecode(templatefile("${path.module}/config/compute/firewall/${filename}", local.substitutions)) }
    routers   = { for filename in local.router_files : replace(filename, ".yaml", "") => yamldecode(templatefile("${path.module}/config/compute/router/${filename}", local.substitutions)) }
    clusters  = { for filename in local.cluster_files : replace(filename, ".yaml", "") => yamldecode(templatefile("${path.module}/config/container/clusters/${filename}", local.substitutions)) }
  }
}

