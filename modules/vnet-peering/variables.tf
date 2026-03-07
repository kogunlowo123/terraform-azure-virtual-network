variable "peering_name_source_to_destination" {
  description = "The name of the peering from source to destination VNet."
  type        = string
}

variable "peering_name_destination_to_source" {
  description = "The name of the peering from destination to source VNet."
  type        = string
  default     = ""
}

variable "source_resource_group_name" {
  description = "The resource group name of the source VNet."
  type        = string
}

variable "source_virtual_network_name" {
  description = "The name of the source virtual network."
  type        = string
}

variable "source_virtual_network_id" {
  description = "The resource ID of the source virtual network."
  type        = string
}

variable "destination_resource_group_name" {
  description = "The resource group name of the destination VNet."
  type        = string
}

variable "destination_virtual_network_name" {
  description = "The name of the destination virtual network."
  type        = string
}

variable "destination_virtual_network_id" {
  description = "The resource ID of the destination virtual network."
  type        = string
}

variable "create_reverse_peering" {
  description = "Whether to create the reverse peering (destination to source)."
  type        = bool
  default     = true
}

variable "allow_virtual_network_access" {
  description = "Allow access between VNets."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "Allow forwarded traffic between VNets."
  type        = bool
  default     = false
}

variable "allow_gateway_transit_source" {
  description = "Allow gateway transit on the source peering."
  type        = bool
  default     = false
}

variable "allow_gateway_transit_destination" {
  description = "Allow gateway transit on the destination peering."
  type        = bool
  default     = false
}

variable "use_remote_gateways_source" {
  description = "Use remote gateways on the source peering."
  type        = bool
  default     = false
}

variable "use_remote_gateways_destination" {
  description = "Use remote gateways on the destination peering."
  type        = bool
  default     = false
}
