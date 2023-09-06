provider "azurerm" {
  features {}
}

module "naming" {
  source = "github.com/cloudnationhq/az-cn-module-tf-naming"

  suffix = ["dev", "demo"]
}

module "rg" {
  source = "github.com/cloudnationhq/az-cn-module-tf-rg"

  groups = {
    bastion = {
      name   = join("-", [module.naming.virtual_network.name, "bastion"])
      region = "westeurope"
    }
    network = {
      name   = join("-", [module.naming.virtual_network.name, "network"])
      region = "westeurope"
    }
  }
}

module "network" {
  source = "github.com/cloudnationhq/az-cn-module-tf-vnet"

  naming = {
    subnet                 = module.naming.subnet.name
    network_security_group = module.naming.network_security_group.name
    route_table            = module.naming.route_table.name
  }

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.network.location
    resourcegroup = module.rg.groups.network.name
    cidr          = ["10.18.0.0/16"]
  }
  depends_on = [module.rg]
}

module "bastion" {
  source = "../../"

  naming = {
    public_ip              = module.naming.public_ip.name
    network_security_group = module.naming.network_security_group.name
  }

  bastion = {
    name                  = module.naming.bastion_host.name
    location              = module.rg.groups.bastion.location
    resourcegroup         = module.rg.groups.bastion.name
    subnet_address_prefix = ["10.18.0.0/27"]
    scale_units           = 2
    sku                   = "Standard"

    enable = {
      copy_paste = false
      file_copy  = false
      ip_connect = true
    }

    vnet = {
      name   = module.network.vnet.name
      rgname = module.network.vnet.resource_group_name
    }
  }
  depends_on = [module.network]
}

