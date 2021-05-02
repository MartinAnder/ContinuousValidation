terraform {
  backend "azurerm" {
    resource_group_name  = "continuous-validation-medium-demo"
    storage_account_name = "continuousvalidation"
    container_name       = "tfstate"
  }
}
