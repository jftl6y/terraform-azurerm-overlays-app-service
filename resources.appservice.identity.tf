# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_user_assigned_identity" "app_identity" {
  location            = local.location
  name                = local.app_user_assigned_identity_name
  resource_group_name = local.resource_group_name
}
