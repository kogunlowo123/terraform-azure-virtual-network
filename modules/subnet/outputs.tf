output "subnet_id" {
  description = "The ID of the subnet."
  value       = azurerm_subnet.this.id
}

output "subnet_name" {
  description = "The name of the subnet."
  value       = azurerm_subnet.this.name
}

output "subnet_address_prefixes" {
  description = "The address prefixes of the subnet."
  value       = azurerm_subnet.this.address_prefixes
}

output "nsg_id" {
  description = "The ID of the network security group (null if not created)."
  value       = length(var.nsg_rules) > 0 ? azurerm_network_security_group.this[0].id : null
}
