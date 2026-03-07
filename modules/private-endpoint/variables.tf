variable "name" {
  description = "The name of the private endpoint."
  type        = string
}

variable "location" {
  description = "The Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to place the private endpoint in."
  type        = string
}

variable "private_connection_resource_id" {
  description = "The resource ID of the private link service or resource to connect to."
  type        = string
}

variable "subresource_names" {
  description = "A list of subresource names for the private endpoint (e.g., blob, sqlServer)."
  type        = list(string)
}

variable "is_manual_connection" {
  description = "Whether the private endpoint connection requires manual approval."
  type        = bool
  default     = false
}

variable "private_dns_zone_ids" {
  description = "A list of private DNS zone IDs to associate with the private endpoint."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to resources."
  type        = map(string)
  default     = {}
}
