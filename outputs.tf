output "vnet_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "vnet_address_space" {
  description = "The address space of the virtual network."
  value       = azurerm_virtual_network.this.address_space
}

output "vnet_guid" {
  description = "The GUID of the virtual network."
  value       = azurerm_virtual_network.this.guid
}

output "subnet_ids" {
  description = "A map of subnet names to their resource IDs."
  value       = { for key, subnet in azurerm_subnet.this : key => subnet.id }
}

output "subnet_address_prefixes" {
  description = "A map of subnet names to their address prefixes."
  value       = { for key, subnet in azurerm_subnet.this : key => subnet.address_prefixes }
}

output "nsg_ids" {
  description = "A map of subnet names to their NSG resource IDs."
  value       = { for key, nsg in azurerm_network_security_group.this : key => nsg.id }
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway (null if not created)."
  value       = var.enable_nat_gateway ? azurerm_nat_gateway.this[0].id : null
}

output "nat_gateway_public_ips" {
  description = "The public IP addresses associated with the NAT Gateway."
  value       = var.enable_nat_gateway ? [for pip in azurerm_public_ip.nat : pip.ip_address] : []
}

output "private_dns_zone_ids" {
  description = "A map of private DNS zone names to their resource IDs."
  value       = { for key, zone in azurerm_private_dns_zone.this : key => zone.id }
}

output "resource_group_name" {
  description = "The name of the resource group."
  value       = var.resource_group_name
}

output "location" {
  description = "The Azure region of the virtual network."
  value       = azurerm_virtual_network.this.location
}
