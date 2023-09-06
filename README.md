# Bastion Host

This Terraform module simplifies the creation of a secure bastion host for remote access to private instances within a network, with configurable options for security groups, instance type, and key pair authentication.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Features

- includes support for a predefined network security group and rules
- enables utilization of existing virtual networks
- utilization of terratest for robust validation.

The below examples shows the usage when consuming the module:

## Usage: simple

```hcl
module "bastion" {
  source = "../../"

  naming = {
    public_ip              = module.naming.public_ip.name
    network_security_group = module.naming.network_security_group.name
  }

  bastion = {
    name                  = module.naming.bastion_host.name
    location              = module.global.groups.demo.location
    resourcegroup         = module.global.groups.demo.name
    subnet_address_prefix = ["10.18.0.0/27"]
    scale_units           = 2

    vnet = {
      name   = module.network.vnet.name
      rgname = module.network.vnet.resource_group_name
    }
  }
  depends_on = [module.network]
}
```

## Usage: standard sku features

```hcl
module "bastion" {
  source = "../../"

  naming = {
    public_ip              = module.naming.public_ip.name
    network_security_group = module.naming.network_security_group.name
  }

  bastion = {
    name                  = module.naming.bastion_host.name
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
```

## Resources

| Name | Type |
| :-- | :-- |
| [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_bastion_host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_network_security_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |

## Data Sources

| Name | Type |
| :-- | :-- |
| [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | datasource |

## Inputs

| Name | Description | Type | Required |
| :-- | :-- | :-- | :-- |
| `bastion` | describes bastion related configuration | object | yes |
| `naming` | contains naming convention | string | yes |

## Outputs

| Name | Description |
| :-- | :-- |
| `bastion` | contains all bastion related configuration |

## Testing

The github repository utilizes a Makefile to conduct tests to evaluate and validate different configurations of the module. These tests are designed to enhance its stability and reliability.

Before initiating the tests, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) incorporates three distinct test variations. The first one, a local deployment test, is designed for local deployments and allows the overriding of workload and environment values. It includes additional checks and can be initiated using the command ```make test_local```.

The second variation is an extended test. This test performs additional validations and serves as the default test for the module within the github workflow.

The third variation allows for specific deployment tests. By providing a unique test name in the github workflow, it overrides the default extended test, executing the specific deployment test instead.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/az-cn-module-tf-bastion/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/az-cn-module-tf-bastion/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/bastion/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/virtualnetwork/bastion-hosts)

