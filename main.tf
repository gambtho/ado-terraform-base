provider "azurerm" {
  version         = "=1.27.1"
  tenant_id       = "${var.tenant}"
  subscription_id = "${var.subscription}"
  client_id       = "${var.ARM_CLIENT_ID}"
  client_secret   = "${var.ARM_CLIENT_SECRET}"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}
