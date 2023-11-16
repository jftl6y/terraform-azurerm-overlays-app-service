# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_linux_function_app" "func" {
  depends_on = [
    azurerm_service_plan.asp,
    azurerm_application_insights.app_service_app_insights,
    module.mod_storage_account
  ]
  count               = var.app_service_plan_os_type == "Linux" && var.app_service_resource_type == "FunctionApp" ? 1 : 0
  name                = local.app_service_name
  resource_group_name = local.resource_group_name
  location            = local.location

  storage_account_name       = module.mod_storage_account.0.storage_account_name
  storage_account_access_key = module.mod_storage_account.0.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.0.id

  key_vault_reference_identity_id = azurerm_user_assigned_identity.app_identity.id

  site_config {
    always_on                              = var.linux_function_app_site_config.always_on
    api_definition_url                     = var.linux_function_app_site_config.api_definition_url
    api_management_api_id                  = var.linux_function_app_site_config.api_management_api_id
    app_command_line                       = var.linux_function_app_site_config.app_command_line
    app_scale_limit                        = var.linux_function_app_site_config.app_scale_limit
    application_insights_connection_string = var.linux_function_app_site_config.application_insights_connection_string
    application_insights_key               = var.linux_function_app_site_config.application_insights_key

    application_stack {
      dynamic "docker" {
        for_each = var.linux_function_app_site_config.application_stack.docker == null ? [] : [1]
        content {
          registry_url      = var.linux_function_app_site_config.application_stack.docker == null ? null : var.linux_function_app_site_config.application_stack.docker.registry_url
          image_name        = var.linux_function_app_site_config.application_stack.docker == null ? null : var.linux_function_app_site_config.application_stack.docker.image_name
          image_tag         = var.linux_function_app_site_config.application_stack.docker == null ? null : var.linux_function_app_site_config.application_stack.docker.image_tag
          registry_username = var.linux_function_app_site_config.application_stack.docker == null ? null : var.linux_function_app_site_config.application_stack.docker.registry_username
        }
      }
      dotnet_version = var.linux_function_app_site_config.application_stack.dotnet_version

      use_dotnet_isolated_runtime = var.linux_function_app_site_config.application_stack.use_dotnet_isolated_runtime
      java_version                = var.linux_function_app_site_config.application_stack.java_version
      node_version                = var.linux_function_app_site_config.application_stack.node_version
      python_version              = var.linux_function_app_site_config.application_stack.python_version
      powershell_core_version     = var.linux_function_app_site_config.application_stack.powershell_core_version
      use_custom_runtime          = var.linux_function_app_site_config.application_stack.use_custom_runtime
    }

    app_service_logs {
      disk_quota_mb         = var.linux_function_app_site_config.app_service_logs == null ? null : var.linux_function_app_site_config.app_service_logs.disk_quota_mb
      retention_period_days = var.linux_function_app_site_config.app_service_logs == null ? null : var.linux_function_app_site_config.app_service_logs.retention_period_days
    }

    # Container settings
    container_registry_use_managed_identity       = var.linux_function_app_site_config.container_registry_use_managed_identity == null ? false : var.linux_function_app_site_config.container_registry_use_managed_identity
    container_registry_managed_identity_client_id = var.linux_function_app_site_config.application_stack.docker == null ? null : "${module.mod_container_registry.login_server}/${var.linux_function_app_site_config.application_stack.docker_image}"

    cors {
      allowed_origins     = var.linux_function_app_site_config.cors == null ? null : var.linux_function_app_site_config.cors.allowed_origins
      support_credentials = var.linux_function_app_site_config.cors == null ? null : var.linux_function_app_site_config.cors.support_credentials
    }

    default_documents                 = var.linux_function_app_site_config.default_documents
    elastic_instance_minimum          = var.linux_function_app_site_config.elastic_instance_minimum
    ftps_state                        = var.linux_function_app_site_config.ftps_state
    health_check_path                 = var.linux_function_app_site_config.health_check_path
    health_check_eviction_time_in_min = var.linux_function_app_site_config.health_check_eviction_time_in_min
    http2_enabled                     = var.linux_function_app_site_config.http2_enabled
    #ip_restriction                   //todo
    load_balancing_mode       = var.linux_function_app_site_config.load_balancing_mode
    managed_pipeline_mode     = var.linux_function_app_site_config.managed_pipeline_mode
    minimum_tls_version       = var.linux_function_app_site_config.minimum_tls_version
    pre_warmed_instance_count = var.linux_function_app_site_config.pre_warmed_instance_count
    remote_debugging_enabled  = var.linux_function_app_site_config.remote_debugging_enabled
    remote_debugging_version  = var.linux_function_app_site_config.remote_debugging_version
    #scm_ip_restriction               //todo
    scm_minimum_tls_version     = var.linux_function_app_site_config.scm_minimum_tls_version
    scm_use_main_ip_restriction = var.linux_function_app_site_config.scm_use_main_ip_restriction
    use_32_bit_worker           = var.linux_function_app_site_config.use_32_bit_worker
    vnet_route_all_enabled      = var.linux_function_app_site_config.vnet_route_all_enabled
    websockets_enabled          = var.linux_function_app_site_config.websockets_enabled
    worker_count                = var.linux_function_app_site_config.worker_count

  }

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.app_service_app_insights[0].instrumentation_key
    APPINSIGHTS_CONNECTION_STRING  = azurerm_application_insights.app_service_app_insights[0].connection_string
    WEBSITE_RUN_FROM_PACKAGE       = var.website_run_from_package
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.app_identity.id
    ]
  }
  tags = merge(var.add_tags, local.default_tags)
}

resource "azurerm_linux_function_app_slot" "slot" {
  depends_on = [
    azurerm_linux_function_app.func
  ]
  count                = var.app_service_plan_os_type == "Linux" && var.app_service_resource_type == "FunctionApp" ? var.deployment_slot_count : 0
  name                 = "${local.app_service_name}-slot-${count.index + 1}"
  function_app_id      = azurerm_linux_function_app.func[0].id
  storage_account_name = module.mod_storage_account.0.storage_account_name

  site_config {}
}
