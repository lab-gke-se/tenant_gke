module "storage_bucket" {
  source   = "../modules/storage/bucket"
  for_each = try(local.buckets, {})

  project = local.projects.prj_dev_tenant_1.project_id

  name                        = each.value.name
  default_kms_key             = try(each.value.default_kms_key, null)
  public_access_prevention    = try(each.value.public_access_prevention, null)
  uniform_bucket_level_access = try(each.value.uniform_bucket_level_access, null)
  labels                      = try(each.value.labels, null)
  location                    = try(each.value.location, null)
  logging                     = try(each.value.logging, null)
  objectRetention             = try(each.value.objectRetention, null)
  retentionPolicy             = try(each.value.retentionPolicy, null)
  softDeletePolicy            = try(each.value.softDeletePolicy, null)
  default_storage_class       = try(each.value.default_storage_class, null)
  versioning_enabled          = try(each.value.versioning_enabled, null)
}

moved {
  from = module.storage_bucket.google_storage_bucket.bucket
  to   = module.storage_bucket["lab-gke-se-dev-tenant-1-bucket"].google_storage_bucket.bucket
}
