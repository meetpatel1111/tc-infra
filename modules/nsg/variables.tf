variable "resource_group_name" {
  type = string
}
variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "rules" {
  type = list(object({
    name                       = string, priority = number, direction = string, access = string, protocol = string,
    source_port_range          = string, destination_port_range = string,
    source_address_prefixes    = optional(list(string)), source_address_prefix = optional(string),
    destination_address_prefix = optional(string), destination_address_prefixes = optional(list(string)),
    description                = optional(string)
  }))
}
variable "tags" {
  type    = map(string)
  default = {}
}
