# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############
# Outputs    ##
###############

output "service_plan_id" {
  description = "ID of the Service Plan"
  value       = azurerm_service_plan.asp.0.id
}