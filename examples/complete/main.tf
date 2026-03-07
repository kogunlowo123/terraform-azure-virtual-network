###############################################################################
# Complete Example - VNet with all features enabled
###############################################################################

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-vnet-complete-example"
  location = "East US"
}

###############################################################################
# DDoS Protection Plan
###############################################################################

resource "azurerm_network_ddos_protection_plan" "example" {
  name                = "ddos-plan-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

###############################################################################
# Log Analytics Workspace
###############################################################################

resource "azurerm_log_analytics_workspace" "example" {
  name                = "law-vnet-complete-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

###############################################################################
# Network Watcher
###############################################################################

resource "azurerm_network_watcher" "example" {
  name                = "nw-complete-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

###############################################################################
# Virtual Network Module
###############################################################################

module "vnet" {
  source = "../../"

  name                = "vnet-complete-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16", "172.16.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  # DDoS Protection
  enable_ddos_protection  = true
  ddos_protection_plan_id = azurerm_network_ddos_protection_plan.example.id

  # Subnets
  subnets = {
    "web" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      nsg_rules = [
        {
          name                   = "allow-http"
          priority               = 100
          direction              = "Inbound"
          access                 = "Allow"
          protocol               = "Tcp"
          destination_port_range = "80"
        },
        {
          name                   = "allow-https"
          priority               = 110
          direction              = "Inbound"
          access                 = "Allow"
          protocol               = "Tcp"
          destination_port_range = "443"
        },
        {
          name                       = "deny-all-inbound"
          priority                   = 4096
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
        }
      ]
    }
    "app" = {
      address_prefixes = ["10.0.2.0/24"]
      delegation = {
        name                    = "app-service"
        service_delegation_name = "Microsoft.Web/serverFarms"
        actions                 = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
      nsg_rules = [
        {
          name                       = "allow-web"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_address_prefix      = "10.0.1.0/24"
          destination_port_range     = "8080"
        }
      ]
    }
    "data" = {
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
      nsg_rules = [
        {
          name                       = "allow-app"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_address_prefix      = "10.0.2.0/24"
          destination_port_range     = "1433"
        }
      ]
    }
    "private-endpoints" = {
      address_prefixes = ["10.0.4.0/24"]
      nsg_rules = [
        {
          name                       = "deny-all-inbound"
          priority                   = 4096
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
        }
      ]
    }
    "aci" = {
      address_prefixes = ["172.16.1.0/24"]
      delegation = {
        name                    = "aci-delegation"
        service_delegation_name = "Microsoft.ContainerInstance/containerGroups"
        actions                 = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }

  # NAT Gateway
  enable_nat_gateway          = true
  nat_gateway_idle_timeout    = 10
  nat_gateway_public_ip_count = 2

  # Flow Logs
  enable_flow_logs           = true
  network_watcher_name       = azurerm_network_watcher.example.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  # Private DNS Zones
  private_dns_zones = [
    {
      name = "privatelink.blob.core.windows.net"
    },
    {
      name = "privatelink.database.windows.net"
    },
    {
      name = "privatelink.vaultcore.azure.net"
    }
  ]

  tags = {
    Environment = "production"
    Example     = "complete"
    CostCenter  = "IT-12345"
  }
}

###############################################################################
# Private Endpoint Example
###############################################################################

resource "azurerm_storage_account" "example" {
  name                     = "stvnetcompleteexample"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

module "storage_private_endpoint" {
  source = "../../modules/private-endpoint"

  name                           = "pe-storage-blob"
  location                       = azurerm_resource_group.example.location
  resource_group_name            = azurerm_resource_group.example.name
  subnet_id                      = module.vnet.subnet_ids["private-endpoints"]
  private_connection_resource_id = azurerm_storage_account.example.id
  subresource_names              = ["blob"]
  private_dns_zone_ids           = [module.vnet.private_dns_zone_ids["privatelink.blob.core.windows.net"]]

  tags = {
    Environment = "production"
  }
}

###############################################################################
# Outputs
###############################################################################

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "vnet_address_space" {
  value = module.vnet.vnet_address_space
}

output "subnet_ids" {
  value = module.vnet.subnet_ids
}

output "nsg_ids" {
  value = module.vnet.nsg_ids
}

output "nat_gateway_id" {
  value = module.vnet.nat_gateway_id
}

output "nat_gateway_public_ips" {
  value = module.vnet.nat_gateway_public_ips
}

output "private_dns_zone_ids" {
  value = module.vnet.private_dns_zone_ids
}

output "private_endpoint_ip" {
  value = module.storage_private_endpoint.private_endpoint_ip_address
}
