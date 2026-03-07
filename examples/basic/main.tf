###############################################################################
# Basic Example - Simple VNet with two subnets
###############################################################################

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-vnet-basic-example"
  location = "East US"
}

module "vnet" {
  source = "../../"

  name                = "vnet-basic-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "frontend" = {
      address_prefixes = ["10.0.1.0/24"]
    }
    "backend" = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }

  tags = {
    Environment = "dev"
    Example     = "basic"
  }
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "subnet_ids" {
  value = module.vnet.subnet_ids
}
