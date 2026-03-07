# VNet Peering Module

This submodule creates bidirectional Azure Virtual Network peering between two VNets.

## Usage

```hcl
module "vnet_peering" {
  source = "../../modules/vnet-peering"

  peering_name_source_to_destination = "hub-to-spoke"
  peering_name_destination_to_source = "spoke-to-hub"

  source_resource_group_name  = "hub-rg"
  source_virtual_network_name = "hub-vnet"
  source_virtual_network_id   = module.hub_vnet.vnet_id

  destination_resource_group_name  = "spoke-rg"
  destination_virtual_network_name = "spoke-vnet"
  destination_virtual_network_id   = module.spoke_vnet.vnet_id

  allow_forwarded_traffic     = true
  allow_gateway_transit_source = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| peering_name_source_to_destination | Name of the source-to-destination peering | `string` | n/a | yes |
| peering_name_destination_to_source | Name of the destination-to-source peering | `string` | `""` | no |
| source_resource_group_name | Source VNet resource group | `string` | n/a | yes |
| source_virtual_network_name | Source VNet name | `string` | n/a | yes |
| source_virtual_network_id | Source VNet resource ID | `string` | n/a | yes |
| destination_resource_group_name | Destination VNet resource group | `string` | n/a | yes |
| destination_virtual_network_name | Destination VNet name | `string` | n/a | yes |
| destination_virtual_network_id | Destination VNet resource ID | `string` | n/a | yes |
| create_reverse_peering | Create the reverse peering | `bool` | `true` | no |
| allow_virtual_network_access | Allow VNet access | `bool` | `true` | no |
| allow_forwarded_traffic | Allow forwarded traffic | `bool` | `false` | no |
| allow_gateway_transit_source | Gateway transit on source | `bool` | `false` | no |
| allow_gateway_transit_destination | Gateway transit on destination | `bool` | `false` | no |
| use_remote_gateways_source | Use remote gateways on source | `bool` | `false` | no |
| use_remote_gateways_destination | Use remote gateways on destination | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| peering_id_source_to_destination | The ID of the source-to-destination peering |
| peering_id_destination_to_source | The ID of the destination-to-source peering |
| peering_state_source_to_destination | The peering state |
