resource "google_secret_manager_secret" "certificates" {
  project   = local.projects.prj_dev_tenant_1.project_id
  secret_id = "certificates"

  replication {
    user_managed {
      replicas {
        location = "us-east4"
        customer_managed_encryption {
          kms_key_name = module.prj_tenant_1_kms_key.key_id
        }
      }
    }
  }

  depends_on = [module.prj_tenant_1_kms_key]
}

resource "google_secret_manager_secret_version" "version" {
  secret = google_secret_manager_secret.certificates.id

  secret_data = "dummy-certificate"
}

