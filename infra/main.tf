locals {
  common_tags = var.tags
}

resource "azurerm_resource_group" "platform" {
  name     = "rg-platform"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "landing" {
  name     = "rg-landing"
  location = var.location
  tags     = local.common_tags
}

# Example: create a VNet + NSG (both free) to demonstrate network baseline without costy SKUs
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-landing"
  location            = azurerm_resource_group.landing.location
  resource_group_name = azurerm_resource_group.landing.name
  address_space       = ["10.10.0.0/16"]
  tags                = local.common_tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.landing.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]

}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-landing"
  location            = azurerm_resource_group.landing.location
  resource_group_name = azurerm_resource_group.landing.name
  tags                = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.nsg.id

}
