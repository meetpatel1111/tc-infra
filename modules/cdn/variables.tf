variable "resource_group_name" {
  type = string
}
variable "profile_name" {
  type = string
}
variable "endpoint_name" {
  type = string
}
variable "location" {
  type = string
}
variable "sku" {
  type = string
}
variable "origin" {
  type = object({ host_name = string, origin_host_header = string, http_port = number, https_port = number })
}
variable "is_http_allowed" {
  type = bool
}
variable "is_https_allowed" {
  type = bool
}
variable "compression_enabled" {
  type = bool
}
variable "content_types_to_compress" {
  type = list(string)
}
variable "querystring_caching_behavior" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
