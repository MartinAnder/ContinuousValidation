resource "azurerm_resource_group" "af-rg" {
  name     = "example-rg"
  location = "North europe"
}

resource "random_string" "af-name-noise" {
  length  = 5
  special = false
  lower   = false
  upper   = true
  number  = true
}

resource "azurerm_storage_account" "af-sa" {
  name                     = "afstorageaccount${random_string.af-name-noise.result}"
  resource_group_name      = azurerm_resource_group.af-rg.name
  location                 = azurerm_resource_group.af-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "af-service-plan" {
  name                = "example-service-plan"
  resource_group_name = azurerm_resource_group.af-rg.name
  location            = azurerm_resource_group.af-rg.location
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "af" {
  name                       = "pr-${var.pr-number}-hello-medium-${random_string.af-name-noise.result}"
  location                   = azurerm_resource_group.af-rg.location
  resource_group_name        = azurerm_resource_group.af-rg.name
  app_service_plan_id        = azurerm_app_service_plan.af-service-plan.id
  storage_account_name       = azurerm_storage_account.af-sa.name
  storage_account_access_key = azurerm_storage_account.af-sa.primary_access_key
  version                    = "~3"

  https_only = true

  site_config {
    always_on = true
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "dotnet"
    FUNCTION_APP_EDIT_MODE   = "readonly"
  }
}


resource "azuread_application" "af-application" {
  name                       = "af-application"
  available_to_other_tenants = false
}

resource "azuread_service_principal" "af-sp" {
  application_id               = azuread_application.af-application.application_id
  app_role_assignment_required = true
}

resource "random_password" "af-sp-random-password" {
  length  = 64
  special = false
}

resource "azuread_service_principal_password" "af-sp-random-password" {
  service_principal_id = azuread_service_principal.af-sp.id
  value                = random_password.af-sp-random-password.result
  end_date_relative    = "438000h"
}

resource "azurerm_role_assignment" "af-sp-role-assignment" {
  principal_id         = azuread_service_principal.af-sp.id
  scope                = azurerm_function_app.af.id
  role_definition_name = "contributor"
}







