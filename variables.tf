###############################################################################
# Virtual Network
###############################################################################

variable "name" {
  description = "The name of the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the virtual network is created."
  type        = string
}

variable "location" {
  description = "The Azure region where the virtual network will be deployed."
  type        = string
}

variable "address_spaces" {
  description = "A list of address spaces (CIDR blocks) for the virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "A list of custom DNS server IP addresses. If empty, Azure-provided DNS is used."
  type        = list(string)
  default     = []
}

###############################################################################
# Subnets
###############################################################################

variable "subnets" {
  description = <<-EOT
    A map of subnet objects to create within the virtual network.
    Each subnet object supports:
      - address_prefixes   : list of CIDR blocks for the subnet
      - service_endpoints  : (optional) list of service endpoints to associate
      - delegation         : (optional) object with name, service_delegation_name, and actions
      - nsg_rules          : (optional) list of NSG rule objects
  EOT
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name                       = string
      service_delegation_name    = string
      actions                    = optional(list(string), [])
    }), null)
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string, "*")
      destination_port_range     = optional(string, "*")
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
    })), [])
  }))
  default = {}
}

###############################################################################
# NAT Gateway
###############################################################################

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway and associate it with subnets."
  type        = bool
  default     = false
}

variable "nat_gateway_idle_timeout" {
  description = "The idle timeout in minutes for the NAT Gateway."
  type        = number
  default     = 4
}

variable "nat_gateway_public_ip_count" {
  description = "The number of public IP addresses to allocate for the NAT Gateway."
  type        = number
  default     = 1
}

###############################################################################
# DDoS Protection
###############################################################################

variable "enable_ddos_protection" {
  description = "Whether to enable DDoS Protection for the virtual network."
  type        = bool
  default     = false
}

variable "ddos_protection_plan_id" {
  description = "The ID of the DDoS Protection Plan to associate with the virtual network. Required when enable_ddos_protection is true."
  type        = string
  default     = null
}

###############################################################################
# Flow Logs
###############################################################################

variable "enable_flow_logs" {
  description = "Whether to enable NSG flow logs."
  type        = bool
  default     = false
}

variable "network_watcher_name" {
  description = "The name of the Network Watcher resource. Required when enable_flow_logs is true."
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "The resource ID of the Log Analytics Workspace for flow log traffic analytics. Required when enable_flow_logs is true."
  type        = string
  default     = null
}

###############################################################################
# Private DNS Zones
###############################################################################

variable "private_dns_zones" {
  description = <<-EOT
    A list of private DNS zone objects to create and link to virtual networks.
    Each object supports:
      - name         : the DNS zone name (e.g. privatelink.blob.core.windows.net)
      - linked_vnets : list of VNet resource IDs to link the zone to (in addition to this VNet)
  EOT
  type = list(object({
    name         = string
    linked_vnets = optional(list(string), [])
  }))
  default = []
}

###############################################################################
# Tags
###############################################################################

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
