module "service_account" {
  source       = "github.com/lab-gke-se/modules//iam/service_account?ref=main"
  project      = local.projects.prj_dev_tenant_1.project_id
  name         = "gke-cluster"
  display_name = "GKE Cluster Service Account"
  description  = "service account for GKE Cluster"
}

resource "google_project_iam_member" "monitoring_viewer" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${module.service_account.email}"
}

resource "google_project_iam_member" "monitoring_metricWriter" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${module.service_account.email}"
}

resource "google_project_iam_member" "logging_logWriter" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${module.service_account.email}"
}

resource "google_project_iam_member" "stackdriver_resourceMetadata_writer" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${module.service_account.email}"
}

resource "google_project_iam_member" "autoscaling_metricsWriter" {
  project = local.projects.prj_dev_tenant_1.project_id
  role    = "roles/autoscaling.metricsWriter"
  member  = "serviceAccount:${module.service_account.email}"
}

