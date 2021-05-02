output "sdk-auth" {
  value = jsonencode({
    "clientId"       = azuread_service_principal.af-sp.application_id
    "clientSecret"   = azuread_service_principal_password.af-sp-random-password.value
    "subscriptionId" = data.azurerm_client_config.current.subscription_id
    "tenantId"       = data.azurerm_client_config.current.tenant_id
  })
  sensitive = true
}

output "azure-function-name" {
  value = azurerm_function_app.af.name
}
