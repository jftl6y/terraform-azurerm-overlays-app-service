# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed
data "azurerm_client_config" "current" {}

data "azurerm_app_service_environment_v3" "ase" {
  count               = var.enable_app_service_environment ? 1 : 0
  name                = var.app_service_environment_name
  resource_group_name = local.resource_group_name
}

data "azurerm_virtual_network" "pe_vnet" {
  name                = var.virtual_network_name
  resource_group_name = local.resource_group_name
}

data "azurerm_subnet" "pe_subnet" {
  name                 = var.private_endpoint_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = local.resource_group_name
}

data "azurerm_service_plan" "existing_asp" {
  count               = var.create_app_service_plan == false && var.existing_app_service_plan_name != null ? 1 : 0
  name                = var.existing_app_service_plan_name
  resource_group_name = local.resource_group_name
}

