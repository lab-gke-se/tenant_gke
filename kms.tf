module "prj_tenant_1_kms_key_ring" {
  source = "github.com/lab-gke-se/modules//kms/key_ring?ref=main"

  name     = "${local.projects["prj_dev_tenant_1"]}-gke-key-ring"
  project  = local.projects["prj_dev_tenant_1"].project_id
  location = local.location
}

module "prj_tenant_1_kms_key" {
  source = "github.com/lab-gke-se/modules//kms/key?ref=main"

  name     = "${local.projects["prj_dev_tenant_1"]}-gke-key"
  project  = local.projects["prj_dev_tenant_1"].project_id
  key_ring = module.prj_tenant_1_kms_key_ring.id
  services = local.prj_dev_tenant_1_services
}

