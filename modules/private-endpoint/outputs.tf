output "private_endpoint_id" {
  description = "The ID of the private endpoint."
  value       = azurerm_private_endpoint.this.id
}

output "private_endpoint_ip_address" {
  description = "The private IP address of the private endpoint."
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}

output "private_endpoint_fqdn" {
  description = "The custom DNS configurations of the private endpoint."
  value       = azurerm_private_endpoint.this.custom_dns_configs
}
