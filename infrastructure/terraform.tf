terraform {
  backend "azurerm" {
    resource_group_name  = "andersen"
    storage_account_name = "shopcrwlterraformstate"
    container_name       = "tfstate"
  }
}
