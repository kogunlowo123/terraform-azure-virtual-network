# Private Endpoint Module

This submodule creates an Azure Private Endpoint with optional Private DNS Zone integration.

## Usage

```hcl
module "private_endpoint" {
  source = "../../modules/private-endpoint"

  name                           = "storage-pe"
  location                       = "eastus"
  resource_group_name            = azurerm_resource_group.example.name
  subnet_id                      = module.vnet.subnet_ids["private-endpoints"]
  private_connection_resource_id = azurerm_storage_account.example.id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = [module.vnet.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | The name of the private endpoint | `string` | n/a | yes |
| location | The Azure region | `string` | n/a | yes |
| resource_group_name | The name of the resource group | `string` | n/a | yes |
| subnet_id | The subnet ID for the private endpoint | `string` | n/a | yes |
| private_connection_resource_id | The resource ID to connect to | `string` | n/a | yes |
| subresource_names | Subresource names (e.g., blob) | `list(string)` | n/a | yes |
| is_manual_connection | Whether manual approval is required | `bool` | `false` | no |
| private_dns_zone_ids | DNS zone IDs for integration | `list(string)` | `[]` | no |
| tags | Tags to assign to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| private_endpoint_id | The ID of the private endpoint |
| private_endpoint_ip_address | The private IP address |
| private_endpoint_fqdn | Custom DNS configurations |
