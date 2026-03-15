resource "azurerm_resource_group" "test" {
  name     = "rg-vnet-test"
  location = "eastus2"
}

module "test" {
  source = "../"

  name                = "vnet-test"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location

  address_spaces = ["10.0.0.0/16"]

  subnets = {
    "snet-web" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      nsg_rules = [
        {
          name                       = "allow-https-inbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }
    "snet-app" = {
      address_prefixes = ["10.0.2.0/24"]
      nsg_rules = [
        {
          name                       = "allow-web-to-app"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          destination_port_range     = "8080"
          source_address_prefix      = "10.0.1.0/24"
          destination_address_prefix = "*"
        }
      ]
    }
    "snet-data" = {
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = ["Microsoft.Sql"]
    }
  }

  enable_nat_gateway = false

  tags = {
    Environment = "test"
    Terraform   = "true"
  }
}
