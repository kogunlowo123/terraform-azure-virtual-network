# Subnet Module

This submodule creates an Azure subnet with optional NSG rules, service endpoints, and delegation.

## Usage

```hcl
module "subnet" {
  source = "../../modules/subnet"

  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = module.vnet.vnet_name
  location             = "eastus"
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  nsg_rules = [
    {
      name                   = "allow-https"
      priority               = 100
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      destination_port_range = "443"
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | The name of the subnet | `string` | n/a | yes |
| resource_group_name | The name of the resource group | `string` | n/a | yes |
| virtual_network_name | The name of the virtual network | `string` | n/a | yes |
| location | The Azure region | `string` | n/a | yes |
| address_prefixes | The address prefixes for the subnet | `list(string)` | n/a | yes |
| service_endpoints | Service endpoints to associate | `list(string)` | `[]` | no |
| delegation | Delegation block for the subnet | `object` | `null` | no |
| nsg_rules | NSG rules to apply | `list(object)` | `[]` | no |
| tags | Tags to assign to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| subnet_id | The ID of the subnet |
| subnet_name | The name of the subnet |
| subnet_address_prefixes | The address prefixes of the subnet |
| nsg_id | The ID of the NSG (null if not created) |
