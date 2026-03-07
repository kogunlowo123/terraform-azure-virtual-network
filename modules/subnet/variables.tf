variable "name" {
  description = "The name of the subnet."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
}

variable "service_endpoints" {
  description = "A list of service endpoints to associate with the subnet."
  type        = list(string)
  default     = []
}

variable "delegation" {
  description = "A delegation block for the subnet."
  type = object({
    name                    = string
    service_delegation_name = string
    actions                 = optional(list(string), [])
  })
  default = null
}

variable "nsg_rules" {
  description = "A list of NSG rules to apply to the subnet."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = optional(string, "*")
    destination_port_range     = optional(string, "*")
    source_address_prefix      = optional(string, "*")
    destination_address_prefix = optional(string, "*")
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to resources."
  type        = map(string)
  default     = {}
}
