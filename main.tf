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

  network_name                = "dev-network"
  network_project_id          = local.projects["prj_dev_tenant_1"].project_id
  region                      = "us-east4"
  zones                       = ["${local.region}-a", "${local.region}-b", "${local.region}-c"]
  private_endpoint_subnetwork = null
  create_service_account      = false
  service_account             = module.service_account.email
  regional                    = true
  release_channel             = "REGULAR"
  http_load_balancing         = true
  horizontal_pod_autoscaling  = true
  enable_private_nodes        = true
  master_ipv4_cidr_block      = null
  deletion_protection         = false

  cluster_public = {
    cluster_type            = "tenant-gke"
    subnet_name             = "tenant-gke"
    pods_range_name         = "tenant-gke-pods"
    svc_range_name          = "tenant-gke-services"
    enable_private_endpoint = false
    master_authorized_networks = [
      {
        # gcp_public_cidrs_access_enabled = true
        cidr_block   = "77.101.187.225/32"
        display_name = "Dave's Home"
      },
      {
        # gcp_public_cidrs_access_enabled = true
        cidr_block   = "217.8.23.33/32"
        display_name = "Himanshu's Home"
      },
      {
        # gcp_public_cidrs_access_enabled = true
        cidr_block   = "162.124.14.0/24"
        display_name = "Proxy Server"
      },
      {
        # gcp_public_cidrs_access_enabled = true
        cidr_block   = "10.10.1.0/25"
        display_name = "Bastion"
      }
    ]
  }

  cluster_private = {
    cluster_type            = "tenant-gke-private"
    subnet_name             = "tenant-gke-private"
    pods_range_name         = "tenant-gke-pods"
    svc_range_name          = "tenant-gke-services"
    enable_private_endpoint = true
    master_authorized_networks = [
      {
        # gcp_public_cidrs_access_enabled = true
        cidr_block   = "10.10.1.0/25" // subnet range for VM
        display_name = "Bastion"
      },
      {
        # gcp_public_cidrs_access_enabled = true
        cidr_block   = "77.101.187.225/32"
        display_name = "Dave's Home"
      }
    ]
  }

  clusters = {
    cluster_private_1 = {
      cluster_name            = "tenant-gke-private-1"
      subnet_name             = "tenant-gke-1"
      pods_range_name         = "tenant-gke-pods"
      svc_range_name          = "tenant-gke-services"
      enable_private_endpoint = true
      master_authorized_networks = [
        {
          # gcp_public_cidrs_access_enabled = true
          cidr_block   = "10.10.1.0/25" // subnet range for VM
          display_name = "Bastion"
        }
      ]
    }
  }

}
