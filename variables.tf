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

variable "folder_id" {
  type        = string
  description = "Folder ID where the Log Sink should be created. Set to null if not in a folder."
  default     = ""
}

variable "log_sink_in_folder" {
  type        = bool
  description = "Set to true if the Log Sink should be created at the folder level."
  default     = false
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

variable "alerting_notify_emails" {
  type = list(string)
  description = "a list of emails to notify if issue occurs"
}