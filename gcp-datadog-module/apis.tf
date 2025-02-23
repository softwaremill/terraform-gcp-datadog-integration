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

# Enable GCP APIs
resource "google_project_service" "enable_apis" {
  project = var.project_id

  for_each = toset([
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "pubsub.googleapis.com",
    "dataflow.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com"
  ])

  service = each.key
}

# Wait for Dataflow 'producer' SA to be created.
resource "time_sleep" "dataflow_sa_creation" {
  depends_on = [google_project_service.enable_apis]
  create_duration = "55s"
}
