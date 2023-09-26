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
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "network" {
  source = "github.com/cloudnationhq/az-cn-module-tf-vnet"

  naming = local.naming

  vnet = {
    name          = module.naming.virtual_network.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    cidr          = ["10.18.0.0/16"]

    subnets = {
      bastion = {
        name  = "AzureBastionSubnet"
        cidr  = ["10.18.1.0/27"]
        rules = local.rules
      }
    }
  }
}

module "bastion" {
  source = "../../"

  naming = local.naming

  bastion = {
    name          = module.naming.bastion_host.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    subnet        = module.network.subnets.bastion.id
    copy_paste    = true
  }
}
