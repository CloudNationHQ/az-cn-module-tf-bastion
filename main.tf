data "azurerm_subscription" "current" {}

# public ip
resource "azurerm_public_ip" "pip" {
  name                = var.naming.public_ip
  resource_group_name = var.bastion.resourcegroup
  location            = var.bastion.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1, 2, 3]
}

# bastion host
resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion.name
  resource_group_name = var.bastion.resourcegroup
  location            = var.bastion.location

  sku                    = try(var.bastion.sku, "Standard")
  scale_units            = try(var.bastion.scale_units, 2)
  copy_paste_enabled     = try(var.bastion.copy_paste, false)
  file_copy_enabled      = try(var.bastion.file_copy, false)
  tunneling_enabled      = try(var.bastion.tunneling, false)
  ip_connect_enabled     = try(var.bastion.ip_connect, false)
  shareable_link_enabled = try(var.bastion.shareable_link, false)

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion.subnet
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}
