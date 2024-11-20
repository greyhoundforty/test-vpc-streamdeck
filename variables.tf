variable "ibmcloud_api_key" {
  description = "The IBM Cloud API key needed to deploy the VPC and related resources."
  type        = string
}

variable "region" {
  description = "The IBM Cloud region where the VPC and related resources will be deployed."
  type        = string
  default = "br-sao"
}

variable "existing_resource_group" {
    description = "Existing resource group ID to use for all deployed resources. If not provided a new resource group will be created."
    type        = string
    default     = "CDE"
}

variable "classic_access" {
  description = "Whether to enable classic access for the VPC"
  type        = bool
  default     = false
}

variable "default_address_prefix" {
  description = "The default address prefix for the VPC"
  type        = string
  default     = "auto"
}