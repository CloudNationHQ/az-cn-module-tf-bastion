provider "azurerm" {
  features {}
}

module "rg" {
  source = "github.com/cloudnationhq/az-cn-module-tf-rg"

  environment = var.environment

  groups = {
    demo = {
      region = "westeurope"
    }
    network = {
      region = "westeurope"
    }
  }
}

module "network" {
  source = "github.com/cloudnationhq/az-cn-module-tf-vnet"

  workload    = var.workload
  environment = var.environment

  vnet = {
    location      = module.global.groups.network.location
    resourcegroup = module.global.groups.network.name
    cidr          = ["10.18.0.0/16"]
  }
  depends_on = [module.rg]
}

module "bastion" {
  source = "../../"

  workload    = var.workload
  environment = var.environment

  bastion = {
    location              = module.global.groups.demo.location
    resourcegroup         = module.global.groups.demo.name
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

