###############################################################################
# Data Sources
###############################################################################

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_network_watcher" "this" {
  count = var.enable_flow_logs && var.network_watcher_name != null ? 1 : 0

  name                = var.network_watcher_name
  resource_group_name = var.resource_group_name
}
