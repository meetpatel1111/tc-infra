variable "resource_group_name" {
  type = string
}
variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "sku" {
  type = string
}
variable "allocation_method" {
  type = string
}
variable "zones" {
  type    = list(string)
  default = null
}
variable "domain_name_label" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
