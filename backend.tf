terraform {
  backend "azurerm" {
    resource_group_name  = "nm_group"
    storage_account_name = "myterraformstate12345"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
