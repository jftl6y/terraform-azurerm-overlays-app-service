# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  tags = {
    Project = "Azure NoOps"
    Module  = "overlays-app-service"
    Toolkit = "Terraform"
    Example = "basic deployment of Azure Linux App Service with ACR"
  }
}