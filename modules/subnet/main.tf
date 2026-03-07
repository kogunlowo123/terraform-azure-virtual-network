resource "azurerm_subnet" "this" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = length(var.service_endpoints) > 0 ? var.service_endpoints : null

  dynamic "delegation" {
    for_each = var.delegation != null ? [var.delegation] : []
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
  count = length(var.nsg_rules) > 0 ? 1 : 0

  name                = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "this" {
  for_each = {
    for rule in var.nsg_rules :
    rule.name => rule
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
  network_security_group_name = azurerm_network_security_group.this[0].name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  count = length(var.nsg_rules) > 0 ? 1 : 0

  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this[0].id
}
