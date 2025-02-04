
# How to use this module

provider "google" {
  project = var.project_id
  region  = var.subnet_region
}

module "datadog-integration" {
  source                 = "./gcp-datadog-module"
  project_id             = var.project_id
  datadog_api_key        = var.datadog_api_key
  vpc_name               = var.vpc_name
  subnet_name            = var.subnet_name
  subnet_region          = var.subnet_region
  folder_id              = var.folder_id
  log_sink_in_folder     = true
  exclusions             = var.exclusions
  alerting_notify_emails = var.alerting_notify_emails
}
