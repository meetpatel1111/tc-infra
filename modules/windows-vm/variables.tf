variable "resource_group_name" {
  type = string
}
variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "size" {
  type = string
}
variable "nic_id" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "license_type" {
  type = string
}
variable "enable_boot_diag" {
  type = bool
}
variable "boot_diagnostics_storage_uri" {
  type    = string
  default = null
}
variable "source_image_reference" {
  type = object({ publisher = string, offer = string, sku = string, version = string })
}
variable "os_disk" {
  type = object({ name = string, caching = string, storage_account_type = string, disk_size_gb = number })
}
variable "vm_extensions" {
  type = list(object({
    name     = string, publisher = string, type = string, type_handler_version = string,
    settings = map(any), protected_settings = optional(map(any)), auto_upgrade_minor_version = optional(bool, true)
  }))
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
