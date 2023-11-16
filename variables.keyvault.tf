
#######################################
# KeyVault Configuration              #
#######################################

variable "create_app_keyvault" {
  description = "Controls if the keyvault should be created. Default is false."
  type        = bool
  default     = false
}

variable "existing_keyvault_private_dns_zone" {
  description = "Name of an existing private DNS zone to use with the key vault"
  type        = string
  default     = null
}