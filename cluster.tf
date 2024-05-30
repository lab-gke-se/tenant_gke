/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  cluster_type                = "dev-tenant-1"
  network_project_id          = local.projects["prj_dev_tenant_1"].project_id
  network_name                = "dev-network"
  region                      = "europe-west2"
  zones                       = ["${local.region}-a", "${local.region}-b", "${local.region}-c"]
  subnet_name                 = "dev-tenant-1"
  master_auth_subnetwork      = "dev-tenant-1-master"
  pods_range_name             = "dev-tenant-1-pods"
  svc_range_name              = "dev-tenant-1-services"
  private_endpoint_subnetwork = "dev-tenant-1-master"
  create_service_account      = false
  service_account             = module.service_account.email
  regional                    = true
  release_channel             = "REGULAR"
  http_load_balancing         = true
  horizontal_pod_autoscaling  = true
  enable_private_nodes        = true
  enable_private_endpoint     = true
  master_ipv4_cidr_block      = null
  deletion_protection         = false
}


# data "google_client_config" "default" {}

# provider "kubernetes" {
#   host                   = "https://${module.gke.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# }

module "gke" {
  //  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  //  version = "~> 30.0"

  source = "github.com/lab-gke-se/terraform-google-kubernetes-engine//modules/beta-autopilot-private-cluster"

  project_id                 = local.projects.prj_dev_tenant_1.project_id
  name                       = "${local.cluster_type}-cluster-google-module"
  region                     = local.region
  zones                      = local.zones
  network                    = local.network_name
  network_project_id         = local.network_project_id
  subnetwork                 = local.subnet_name
  ip_range_pods              = local.pods_range_name
  ip_range_services          = local.svc_range_name
  create_service_account     = local.create_service_account
  service_account            = module.service_account.email
  regional                   = local.regional
  release_channel            = local.release_channel
  kubernetes_version         = "1.29.1"
  http_load_balancing        = local.http_load_balancing
  horizontal_pod_autoscaling = local.horizontal_pod_autoscaling
  deletion_protection        = local.deletion_protection
  boot_disk_kms_key          = module.prj_tenant_1_kms_key.key_id

  enable_private_nodes    = local.enable_private_nodes
  enable_private_endpoint = local.enable_private_endpoint
  # private_endpoint_subnetwork = local.private_endpoint_subnetwork

  master_authorized_networks = [
    {
      gcp_public_cidrs_access_enabled = true
      cidr_block                      = "162.124.14.1/24"
      display_name                    = "VPC"
    },
  ]

  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = module.prj_tenant_1_kms_key.key_id
  }]

  depends_on = [module.prj_tenant_1_kms_key.key_id]
}

