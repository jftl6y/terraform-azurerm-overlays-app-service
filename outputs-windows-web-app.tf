# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############
# Outputs    ##
###############

output "windows_app_service_id" {
  description = "Id of the Windows App Service"
  value       = try(azurerm_windows_web_app.appService.0.id, null)
}

output "windows_app_service_name" {
  description = "Name of the Windows App Service"
  value       = try(azurerm_windows_web_app.appService.0.name, null)
}

output "windows_app_service_default_site_hostname" {
  description = "The Default Hostname associated with the Windows App Service"
  value       = try(azurerm_windows_web_app.appService.0.default_hostname, null)
}

output "windows_app_service_outbound_ip_addresses" {
  description = "Outbound IP adresses of the Windows App Service"
  value       = try(split(",", azurerm_windows_web_app.appService.0.outbound_ip_addresses), null)
}

output "windows_app_service_possible_outbound_ip_addresses" {
  description = "Possible outbound IP adresses of the Windows App Service"
  value       = try(split(",", azurerm_windows_web_app.appService.0.possible_outbound_ip_addresses), null)
}

output "windows_app_service_site_credential" {
  description = "Site credential block of the Windows App Service"
  value       = try(azurerm_windows_web_app.appService.0.site_credential, null)
}

output "windows_app_service_identity_service_principal_id" {
  description = "Id of the Service principal identity of the Windows App Service"
  value       = try(azurerm_windows_web_app.appService[0].identity[0].principal_id, null)
}

output "windows_app_service_slot_name" {
  description = "Name of the Windows App Service slot"
  value       = try(azurerm_windows_web_app_slot.slot[0].name, null)
}

output "windows_app_service_slot_identity_service_principal_id" {
  description = "Id of the Service principal identity of the Windows App Service slot"
  value       = try(azurerm_windows_web_app_slot.slot[0].identity[0].principal_id, null)
}

