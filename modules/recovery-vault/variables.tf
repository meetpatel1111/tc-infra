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
variable "storage_mode_type" {
  type = string
}
variable "cross_region_restore_enabled" {
  type = bool
}
variable "soft_delete_enabled" {
  type = bool
}
variable "soft_delete_retention_days" {
  type = number
}
variable "enhanced_security_enabled" {
  type = bool
}
variable "cross_subscription_restore_enabled" {
  type = bool
}
variable "public_network_access_enabled" {
  type = bool
}
variable "vm_policies" {
  type = map(object({
    name                  = string, timezone = string, backup_frequency = string, backup_time = string,
    retention_daily_count = number, weekdays = optional(list(string))
  }))
}
variable "sql_workload_policy" {
  type = object({
    name                      = string, timezone = string, full_backup_time = string, full_retention_days = number,
    log_backup_frequency_mins = number, log_retention_days = number
  })
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
