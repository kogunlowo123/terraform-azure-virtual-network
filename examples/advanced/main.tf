###############################################################################
# Advanced Example - VNet with NSGs, NAT Gateway, and Delegated Subnets
###############################################################################

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-vnet-advanced-example"
  location = "East US"
}

module "vnet" {
  source = "../../"

  name                = "vnet-advanced-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

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
        }
      ]
    }
    "app" = {
      address_prefixes = ["10.0.2.0/24"]
      delegation = {
        name                    = "app-service-delegation"
        service_delegation_name = "Microsoft.Web/serverFarms"
        actions                 = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
      nsg_rules = [
        {
          name                       = "allow-web-subnet"
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
      service_endpoints = ["Microsoft.Sql"]
      nsg_rules = [
        {
          name                       = "allow-app-subnet"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_address_prefix      = "10.0.2.0/24"
          destination_port_range     = "1433"
        }
      ]
    }
  }

  enable_nat_gateway          = true
  nat_gateway_idle_timeout    = 10
  nat_gateway_public_ip_count = 2

  tags = {
    Environment = "staging"
    Example     = "advanced"
  }
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "subnet_ids" {
  value = module.vnet.subnet_ids
}

output "nat_gateway_id" {
  value = module.vnet.nat_gateway_id
}
