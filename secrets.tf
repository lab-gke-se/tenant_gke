module "secret" {
  source   = "../modules/secretmanager/secret"
  for_each = try(local.secrets, {})

  project        = local.projects.prj_dev_tenant_1.project_id
  name           = each.value.name
  replication    = try(each.value.replication, null)
  labels         = try(each.value.labels, null)
  topics         = try(each.value.topics, null)
  rotation       = try(each.value.rotation, null)
  versionAliases = try(each.value.versionAliases, null)
  annotations    = try(each.value.annotations, null)
  expireTime     = try(each.value.expireTime, null)
  ttl            = try(each.value.ttl, null)
}

moved {
  from = google_secret_manager_secret.certificates
  to   = module.secret["certificates"].google_secret_manager_secret.secret
}


# resource "google_secret_manager_secret" "certificates" {
#   project   = local.projects.prj_dev_tenant_1.project_id
#   secret_id = "certificates"

#   replication {
#     user_managed {
#       replicas {
#         location = "us-east4"
#         customer_managed_encryption {
#           kms_key_name = local.substitutions.kms_key_prj_tenant_1
#         }
#       }
#     }
#   }

#   depends_on = [module.key]
# }

resource "google_secret_manager_secret_version" "version" {
  secret = module.secret["certificates"].id

  secret_data = "dummy-certificate"
}

