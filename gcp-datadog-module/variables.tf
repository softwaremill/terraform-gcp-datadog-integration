# Copyright 2024 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Mandatory variables

variable "alerting_notify_emails" {
  type = list(string)
  description = "a list of emails to notify if issue occurs"
}

variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project."
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnets used for Dataflow Virtual Machines."
}
variable "subnet_region" {
  type        = string
  description = "Region of the existing subnet, all the resources will be created in this region."
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC used for Dataflow Virtual Machines."
}

# Variables with sane defaults

variable "audit_logtypes" {
  description = "list of audit logtypes"
  type        = list(string)
  default = [
    "ADMIN_READ",
    "DATA_WRITE",
    "DATA_READ"
  ]
}

variable "datadog_site_url" {
  type        = string
  description = "Datadog Logs API URL, it will depends on the Datadog site region (https://docs.datadoghq.com/integrations/google_cloud_platform/#4-create-and-run-the-dataflow-job)."
  default     = "https://http-intake.logs.datadoghq.eu"
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key for integration. Provide it on tf ivocation. Do not store outside of password vault!"
  sensitive   = true
}

variable "dataflow_job_name" {
  type        = string
  description = "Dataflow job name"
  default     = "datadog-export-job"
}

variable "dataflow_machine_type" {
  type        = string
  description = "Machine type to use while spining up a dataflow jobs"
  default     = "e2-small"
}

variable "dataflow_temp_bucket_name" {
  type        = string
  description = "GCS Bucket to write Dataflow temporary files. Must start and end with letter or number. Must be between 3 and 63 characters."
  default     = "temp-files-dataflow-bucket-"
}

variable "folder_id" {
  type        = string
  description = "Folder ID where the Log Sink should be created. Set to null if not in a folder."
  default     = ""
}

variable "inclusion_filter" {
  type        = string
  description = "Additional rules for inclusion filter that are concated with the default audit rule (should begin with OR ...)"
  default     = ""
}

variable "exclusions" {
  type = map(object(
    { description = string
      filter      = string
      disabled    = bool
    }
  ))
  description = "Logging sink exclusions"
  default     = {}
}

variable "log_sink_in_folder" {
  type        = bool
  description = "Set to true if the Log Sink should be created at the folder level."
  default     = false
}

variable "topic_name" {
  type        = string
  description = "Name of the Pub/Sub Topic to receive logs from Google Cloud."
  default     = "datadog-export-topic"
}

