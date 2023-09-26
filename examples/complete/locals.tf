locals {
  rules = [
    {
      name                         = "AllowHttpsInbound"
      description                  = "Allow connection from any host on https"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = 443
      source_address_prefix        = "Internet"
      destination_address_prefix   = "*"
      access                       = "Allow"
      priority                     = 100
      direction                    = "Inbound"
      source_port_ranges           = []
      destination_port_ranges      = []
      source_address_prefixes      = []
      destination_address_prefixes = []
    },
    {
      name                         = "AllowGatewayManagerInbound"
      description                  = "This enables the control plane, that is, Gateway Manager to be able to talk to Azure Bastion."
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = 443
      source_address_prefix        = "GatewayManager"
      destination_address_prefix   = "*"
      access                       = "Allow"
      priority                     = 110
      direction                    = "Inbound"
      source_port_ranges           = []
      destination_port_ranges      = []
      source_address_prefixes      = []
      destination_address_prefixes = []
    },
    {
      name                       = "AllowSshRdpOutbound"
      description                = "Egress Traffic to target VMs: Azure Bastion will reach the target VMs over private IP and SSH/RDP port"
      protocol                   = "*"
      source_port_range          = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
      access                     = "Allow"
      priority                   = 100
      direction                  = "Outbound"
      source_port_ranges         = []
      destination_port_ranges = [
        "22",
        "3389"
      ]
      source_address_prefixes      = []
      destination_address_prefixes = []
    },
    {
      name                         = "AllowAzureCloudOutbound"
      description                  = "Egress Traffic to other public endpoints in Azure"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = 443
      source_address_prefix        = "*"
      destination_address_prefix   = "AzureCloud"
      access                       = "Allow"
      priority                     = 110
      direction                    = "Outbound"
      source_port_ranges           = []
      destination_port_ranges      = []
      source_address_prefixes      = []
      destination_address_prefixes = []
    },
    {
      name                       = "AllowBastionCommunication"
      description                = "Egress Traffic to other public endpoints in Azure"
      protocol                   = "*"
      source_port_range          = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
      access                     = "Allow"
      priority                   = 120
      direction                  = "Outbound"
      source_port_ranges         = []
      destination_port_ranges = [
        "8080",
        "5701"
      ]
      source_address_prefixes      = []
      destination_address_prefixes = []
    },
    {
      name                         = "AllowGetSessionInformation"
      description                  = "Egress Traffic to other public endpoints in Azure"
      protocol                     = "*"
      source_port_range            = "*"
      source_address_prefix        = "*"
      destination_port_range       = 80
      destination_address_prefix   = "Internet"
      access                       = "Allow"
      priority                     = 130
      direction                    = "Outbound"
      source_port_ranges           = []
      destination_port_ranges      = []
      source_address_prefixes      = []
      destination_address_prefixes = []
    }
  ]
}

locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["subnet", "network_security_group", "public_ip"]
}
