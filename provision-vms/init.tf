# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}

# Create a resource group
resource "azurerm_resource_group" "global" {
  location = "${var.region}"
  name     = "${var.resource_group}"
}

# Create a storage account
resource "azurerm_storage_account" "global" {
  account_type        = "Standard_LRS"                          # Only locally redundant
  location            = "${var.region}"
  name                = "${var.storage_account}"
  resource_group_name = "${azurerm_resource_group.global.name}"
}

# copy in the base images
resource "azurerm_storage_container" "global" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "windows" {
  name = "win-image.vhd"
  resource_group_name    = "${azurerm_resource_group.global.name}"
  storage_account_name   = "${azurerm_storage_account.global.name}"
  storage_container_name = "${azurerm_storage_container.global.name}"
  source_uri = "${var.win_image_vhd_uri}"
}

resource "azurerm_storage_blob" "linux" {
  name = "lin-image.vhd"
  resource_group_name    = "${azurerm_resource_group.global.name}"
  storage_account_name   = "${azurerm_storage_account.global.name}"
  storage_container_name = "${azurerm_storage_container.global.name}"
  source_uri = "${var.lin_image_vhd_uri}"
}
