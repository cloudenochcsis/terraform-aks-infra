terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateakpadetsiremote"
    container_name       = "tfstate"
    key                  = "dev.eventbooking.tfstate"
    use_azuread_auth     = false
    use_msi              = true
  }
}
