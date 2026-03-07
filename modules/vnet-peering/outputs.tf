output "peering_id_source_to_destination" {
  description = "The ID of the source-to-destination peering."
  value       = azurerm_virtual_network_peering.source_to_destination.id
}

output "peering_id_destination_to_source" {
  description = "The ID of the destination-to-source peering (null if not created)."
  value       = var.create_reverse_peering ? azurerm_virtual_network_peering.destination_to_source[0].id : null
}

output "peering_state_source_to_destination" {
  description = "The peering state of the source-to-destination peering."
  value       = azurerm_virtual_network_peering.source_to_destination.peering_state
}
