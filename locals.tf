locals {
  # Flatten subnet NSG rules for iteration
  subnet_nsg_rules = flatten([
    for subnet_key, subnet in var.subnets : [
      for rule in subnet.nsg_rules : {
        subnet_key             = subnet_key
        name                   = rule.name
        priority               = rule.priority
        direction              = rule.direction
        access                 = rule.access
        protocol               = rule.protocol
        source_port_range      = rule.source_port_range
        destination_port_range = rule.destination_port_range
        source_address_prefix      = rule.source_address_prefix
        destination_address_prefix = rule.destination_address_prefix
      }
    ]
  ])

  # Map of NSG rules keyed by "subnet_key.rule_name"
  nsg_rules_map = {
    for rule in local.subnet_nsg_rules :
    "${rule.subnet_key}.${rule.name}" => rule
  }

  # Subnets that have at least one NSG rule
  subnets_with_nsg = {
    for key, subnet in var.subnets :
    key => subnet if length(subnet.nsg_rules) > 0
  }

  # Subnets that have delegation configured
  subnets_with_delegation = {
    for key, subnet in var.subnets :
    key => subnet if subnet.delegation != null
  }

  # Private DNS zone map keyed by zone name
  private_dns_zone_map = {
    for zone in var.private_dns_zones :
    zone.name => zone
  }

  # Flatten DNS zone VNet links for iteration
  dns_zone_vnet_links = flatten([
    for zone in var.private_dns_zones : [
      for vnet_id in zone.linked_vnets : {
        zone_name = zone.name
        vnet_id   = vnet_id
        link_key  = "${zone.name}.${md5(vnet_id)}"
      }
    ]
  ])

  dns_zone_vnet_links_map = {
    for link in local.dns_zone_vnet_links :
    link.link_key => link
  }

  # Common tags applied to all resources
  common_tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
}
