module "service_account" {
  source   = "../modules//iam/service_account"
  for_each = try(local.serviceaccounts, {})

  projectId   = each.value.projectId
  email       = each.value.email
  displayName = each.value.displayName
  description = each.value.description
}

resource "google_project_iam_member" "monitoring_viewer" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${module.service_account["gke-cluster"].email}"
}

resource "google_project_iam_member" "monitoring_metricWriter" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${module.service_account["gke-cluster"].email}"
}

resource "google_project_iam_member" "logging_logWriter" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${module.service_account["gke-cluster"].email}"
}

resource "google_project_iam_member" "stackdriver_resourceMetadata_writer" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${module.service_account["gke-cluster"].email}"
}

resource "google_project_iam_member" "autoscaling_metricsWriter" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/autoscaling.metricsWriter"
  member  = "serviceAccount:${module.service_account["gke-cluster"].email}"
}

moved {
  from = module.service_account.google_service_account.service_account
  to   = module.service_account["gke-cluster"].google_service_account.service_account
}
