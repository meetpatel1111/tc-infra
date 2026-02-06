variable "resource_group_name" {
  type = string
}
variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "kind" {
  type = string
}
variable "account_tier" {
  type = string
}
variable "replication_type" {
  type = string
}
variable "min_tls_version" {
  type = string
}
variable "https_only" {
  type = bool
}
variable "allow_public_blob" {
  type = bool
}
variable "shared_key_enabled" {
  type = bool
}
variable "default_to_oauth" {
  type = bool
}
variable "access_tier" {
  type    = string
  default = null
}
variable "containers" {
  type    = list(object({ name = string, access_type = string }))
  default = []
}
variable "enable_static_website" {
  type    = bool
  default = false
}
variable "tags" {
  type    = map(string)
  default = {}
}
