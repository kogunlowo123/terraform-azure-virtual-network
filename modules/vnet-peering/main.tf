resource "azurerm_virtual_network_peering" "source_to_destination" {
  name                         = var.peering_name_source_to_destination
  resource_group_name          = var.source_resource_group_name
  virtual_network_name         = var.source_virtual_network_name
  remote_virtual_network_id    = var.destination_virtual_network_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit_source
  use_remote_gateways          = var.use_remote_gateways_source
}

resource "azurerm_virtual_network_peering" "destination_to_source" {
  count = var.create_reverse_peering ? 1 : 0

  name                         = var.peering_name_destination_to_source
  resource_group_name          = var.destination_resource_group_name
  virtual_network_name         = var.destination_virtual_network_name
  remote_virtual_network_id    = var.source_virtual_network_id
  allow_virtual_network_access = var.allow_virtual_network_access
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit_destination
  use_remote_gateways          = var.use_remote_gateways_destination
}
