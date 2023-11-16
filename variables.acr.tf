# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#######################################
# Azure Container Registry            #
#######################################
variable "create_app_container_registry" {
  description = "Controls if the ACR should be created. Default is false."
  type        = bool
  default     = false
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry. Possible values are Basic, Standard and Premium. Defaults to Premium."
  type        = string
  default     = "Premium"
}

##########################
# ACR Private Endpoint  ##
##########################

variable "enable_acr_private_endpoint" {
  description = "Controls if the private endpoint should be created. Default is false."
  type        = bool
  default     = true
}

variable "existing_acr_private_dns_zone" {
  description = "The id of the existing private DNS Zone to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}