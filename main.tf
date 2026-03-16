resource "azurerm_virtual_network" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_spaces
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection && var.ddos_protection_plan_id != null ? [1] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = length(each.value.service_endpoints) > 0 ? each.value.service_endpoints : null

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation_name
        actions = delegation.value.actions
      }
    }
  }
}

resource "azurerm_network_security_group" "this" {
  for_each = { for key, subnet in var.subnets : key => subnet if length(subnet.nsg_rules) > 0 }

  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = {
    for rule in flatten([
      for subnet_key, subnet in var.subnets : [
        for rule in subnet.nsg_rules : {
          key                        = "${subnet_key}.${rule.name}"
          subnet_key                 = subnet_key
          name                       = rule.name
          priority                   = rule.priority
          direction                  = rule.direction
          access                     = rule.access
          protocol                   = rule.protocol
          source_port_range          = rule.source_port_range
          destination_port_range     = rule.destination_port_range
          source_address_prefix      = rule.source_address_prefix
          destination_address_prefix = rule.destination_address_prefix
        }
      ]
    ]) : rule.key => rule
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this[each.value.subnet_key].name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = { for key, subnet in var.subnets : key => subnet if length(subnet.nsg_rules) > 0 }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_public_ip" "nat" {
  count = var.enable_nat_gateway ? var.nat_gateway_public_ip_count : 0

  name                = "${var.name}-nat-pip-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  name                    = "${var.name}-nat-gw"
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = var.nat_gateway_idle_timeout
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  count = var.enable_nat_gateway ? var.nat_gateway_public_ip_count : 0

  nat_gateway_id       = azurerm_nat_gateway.this[0].id
  public_ip_address_id = azurerm_public_ip.nat[count.index].id
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each = var.enable_nat_gateway ? var.subnets : {}

  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = azurerm_nat_gateway.this[0].id
}

resource "azurerm_storage_account" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name                     = replace("${var.name}flowlogs", "-", "")
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_network_watcher_flow_log" "this" {
  for_each = var.enable_flow_logs ? { for key, subnet in var.subnets : key => subnet if length(subnet.nsg_rules) > 0 } : {}

  network_watcher_name = data.azurerm_network_watcher.this[0].name
  resource_group_name  = var.resource_group_name
  name                 = "${each.key}-flow-log"

  network_security_group_id = azurerm_network_security_group.this[each.key].id
  storage_account_id        = azurerm_storage_account.flow_logs[0].id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 30
  }

  dynamic "traffic_analytics" {
    for_each = var.log_analytics_workspace_id != null ? [1] : []
    content {
      enabled               = true
      workspace_id          = var.log_analytics_workspace_id
      workspace_region      = var.location
      workspace_resource_id = var.log_analytics_workspace_id
      interval_in_minutes   = 10
    }
  }
}

resource "azurerm_private_dns_zone" "this" {
  for_each = { for zone in var.private_dns_zones : zone.name => zone }

  name                = each.value.name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = { for zone in var.private_dns_zones : zone.name => zone }

  name                  = "${var.name}-${replace(each.value.name, ".", "-")}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "additional" {
  for_each = {
    for link in flatten([
      for zone in var.private_dns_zones : [
        for vnet_id in zone.linked_vnets : {
          key       = "${zone.name}.${md5(vnet_id)}"
          zone_name = zone.name
          vnet_id   = vnet_id
        }
      ]
    ]) : link.key => link
  }

  name                  = "link-${each.key}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.value.zone_name].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = false
  tags                  = var.tags
}
