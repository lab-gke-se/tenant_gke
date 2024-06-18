module "storage_bucket" {
  source = "github.com/lab-gke-se/modules//storage/bucket?ref=main"

  name                = "dev-tenant-1-bucket"
  project             = "lab-gke-se"
  location            = "us-east4"
  data_classification = "none"
  kms_key_id          = module.prj_tenant_1_kms_key.key_id
}
