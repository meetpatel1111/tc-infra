variable "resource_group_name" {
  type = string
}
variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "private_ip_address" {
  type    = string
  default = null
}
variable "public_ip_id" {
  type = string
}
variable "nsg_id" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
