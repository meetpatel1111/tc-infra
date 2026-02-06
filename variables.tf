variable "resource_group_name" {
  type = string
}
variable "resource_group_location" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "vnets" {
  type = map(object({ location = string, address_space = list(string), subnets = map(object({ address_prefix = string })) }))
}

variable "nsgs" {
  type = map(object({
    location = string
    rules = list(object({
      name                       = string, priority = number, direction = string, access = string, protocol = string,
      source_port_range          = string, destination_port_range = string,
      source_address_prefixes    = optional(list(string)), source_address_prefix = optional(string),
      destination_address_prefix = optional(string), destination_address_prefixes = optional(list(string)),
      description                = optional(string)
    }))
  }))
}

variable "public_ips" {
  type = map(object({ location = string, sku = string, allocation_method = string, zones = optional(list(string)), domain_name_label = optional(string) }))
}

variable "storage_accounts" {
  type = map(object({
    location              = string, kind = string, tier = string, replication_type = string,
    min_tls_version       = string, https_only = bool, allow_public_blob = bool,
    shared_key_enabled    = bool, default_to_oauth = bool, access_tier = optional(string),
    containers            = optional(list(object({ name = string, access_type = string })), []),
    enable_static_website = optional(bool, false)
  }))
}

variable "nics" {
  type = map(object({ location = string, subnet_key = string, private_ip = optional(string), public_ip_key = string, nsg_key = string }))
}

variable "windows_vms" {
  type = map(object({
    location               = string, size = string, nic_key = string,
    admin_username         = string, admin_password = string, license_type = string,
    enable_boot_diag       = bool, boot_diag_sa_key = optional(string),
    source_image_reference = object({ publisher = string, offer = string, sku = string, version = string }),
    os_disk                = object({ name = string, caching = string, storage_account_type = string, disk_size_gb = number }),
    vm_extensions = optional(list(object({
      name     = string, publisher = string, type = string, type_handler_version = string,
      settings = map(any), protected_settings = optional(map(any)), auto_upgrade_minor_version = optional(bool, true)
    })), [])
  }))
  sensitive = true
}

variable "cdn" {
  type = object({
    profile_name  = string
    endpoint_name = string
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\.-]+$", var.cdn.profile_name))
    error_message = "CDN profile name must start with a letter or number and can only contain letters, numbers, hyphens, and periods."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-]+$", var.cdn.endpoint_name))
    error_message = "CDN endpoint name must start with a letter or number and can only contain letters, numbers, and hyphens."
  }
}

variable "enable_cdn" {
  type    = bool
  default = false
}

variable "recovery_vault" {
  type = object({
    name                          = string, location = string, sku = string,
    storage_mode_type             = string, cross_region_restore_enabled = bool,
    soft_delete_enabled           = bool, soft_delete_retention_days = number,
    enhanced_security_enabled     = bool, cross_subscription_restore_enabled = bool,
    public_network_access_enabled = bool,
    vm_policies                   = map(object({ name = string, timezone = string, backup_frequency = string, backup_time = string, retention_daily_count = number, weekdays = optional(list(string)) })),
    sql_workload_policy           = optional(object({ name = string, timezone = string, full_backup_time = string, full_retention_days = number, log_backup_frequency_mins = number, log_retention_days = number }))
  })
}
