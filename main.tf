module "rg" {
  source   = "./modules/resource-group"
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags
}

locals {
  subnet_id_by_key = merge([
    for vnet_key, vnet in module.vnet : {
      for subnet_name, subnet_id in vnet.subnet_ids :
      "${vnet_key}.${subnet_name}" => subnet_id
    }
  ]...)
}

module "vnet" {
  for_each            = var.vnets
  source              = "./modules/network"
  resource_group_name = module.rg.name
  vnet_name           = each.key
  location            = each.value.location
  address_space       = each.value.address_space
  subnets             = each.value.subnets
  tags                = var.tags
}

module "nsg" {
  for_each            = var.nsgs
  source              = "./modules/nsg"
  resource_group_name = module.rg.name
  name                = each.key
  location            = each.value.location
  rules               = each.value.rules
  tags                = var.tags
}

module "public_ip" {
  for_each            = var.public_ips
  source              = "./modules/public-ip"
  resource_group_name = module.rg.name
  name                = each.key
  location            = each.value.location
  sku                 = each.value.sku
  allocation_method   = each.value.allocation_method
  zones               = try(each.value.zones, null)
  domain_name_label   = try(each.value.domain_name_label, null)
  tags                = var.tags
}

module "storage" {
  for_each = var.storage_accounts
  source   = "./modules/storage-account"
  providers = {
    azurerm = azurerm
    azapi   = azapi
  }
  resource_group_name = module.rg.name
  name                = each.value.name
  location            = each.value.location

  kind               = each.value.kind
  account_tier       = each.value.tier
  replication_type   = each.value.replication_type
  min_tls_version    = each.value.min_tls_version
  https_only         = each.value.https_only
  allow_public_blob  = each.value.allow_public_blob
  shared_key_enabled = each.value.shared_key_enabled
  default_to_oauth   = each.value.default_to_oauth
  access_tier        = try(each.value.access_tier, null)

  containers            = try(each.value.containers, [])
  enable_static_website = try(each.value.enable_static_website, false)

  tags = var.tags
}

module "nic" {
  for_each            = var.nics
  source              = "./modules/nic"
  resource_group_name = module.rg.name
  name                = each.key
  location            = each.value.location

  subnet_id          = local.subnet_id_by_key[each.value.subnet_key]
  private_ip_address = try(each.value.private_ip, null)

  public_ip_id = module.public_ip[each.value.public_ip_key].id
  nsg_id       = module.nsg[each.value.nsg_key].id
  tags         = var.tags
}

module "vm" {
  for_each            = nonsensitive(var.windows_vms)
  source              = "./modules/windows-vm"
  resource_group_name = module.rg.name
  name                = each.key
  location            = each.value.location
  size                = each.value.size

  nic_id = module.nic[each.value.nic_key].id

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password
  license_type   = each.value.license_type

  enable_boot_diag = try(each.value.enable_boot_diag, false)
  boot_diagnostics_storage_uri = (
    try(each.value.boot_diag_sa_key, null) != null
    ? module.storage[each.value.boot_diag_sa_key].primary_blob_endpoint
    : null
  )

  source_image_reference = each.value.source_image_reference
  os_disk                = each.value.os_disk
  vm_extensions          = try(each.value.vm_extensions, [])

  tags = var.tags
}

module "cdn" {
  count               = var.enable_cdn ? 1 : 0
  source              = "./modules/cdn"
  resource_group_name = module.rg.name
  location            = "eastus" # Changed from WestUs to match resource group location
  profile_name        = var.cdn.profile_name
  endpoint_name       = var.cdn.endpoint_name

  # CDN Profile Configuration - Matches template.json
  sku = "Standard_Microsoft"

  # Origin Configuration - Matches template.json
  origin = {
    host_name          = "posterscopeterms.blob.core.windows.net"
    origin_host_header = "posterscopeterms.blob.core.windows.net"
    http_port          = 80
    https_port         = 443
  }

  # CDN Endpoint Configuration - Matches template.json
  is_http_allowed              = true
  is_https_allowed             = true
  compression_enabled          = true
  querystring_caching_behavior = "IgnoreQueryString"

  # Content types to compress - Matches template.json
  content_types_to_compress = [
    "application/eot",
    "application/font",
    "application/font-sfnt",
    "application/javascript",
    "application/json",
    "application/opentype",
    "application/otf",
    "application/pkcs7-mime",
    "application/truetype",
    "application/ttf",
    "application/vnd.ms-fontobject",
    "application/xhtml+xml",
    "application/xml",
    "application/xml+rss",
    "application/x-font-opentype",
    "application/x-font-truetype",
    "application/x-font-ttf",
    "application/x-httpd-cgi",
    "application/x-javascript",
    "application/x-mpegurl",
    "application/x-opentype",
    "application/x-otf",
    "application/x-perl",
    "application/x-ttf",
    "font/eot",
    "font/ttf",
    "font/otf",
    "font/opentype",
    "image/svg+xml",
    "text/css",
    "text/csv",
    "text/html",
    "text/javascript",
    "text/js",
    "text/plain",
    "text/richtext",
    "text/tab-separated-values",
    "text/xml",
    "text/x-script",
    "text/x-component",
    "text/x-java-source"
  ]

  tags = var.tags
}

module "recovery_vault" {
  source = "./modules/recovery-vault"
  providers = {
    azurerm = azurerm
    azapi   = azapi
  }
  resource_group_name = module.rg.name

  name                               = var.recovery_vault.name
  location                           = var.recovery_vault.location
  sku                                = var.recovery_vault.sku
  storage_mode_type                  = var.recovery_vault.storage_mode_type
  cross_region_restore_enabled       = var.recovery_vault.cross_region_restore_enabled
  soft_delete_enabled                = var.recovery_vault.soft_delete_enabled
  soft_delete_retention_days         = var.recovery_vault.soft_delete_retention_days
  enhanced_security_enabled          = var.recovery_vault.enhanced_security_enabled
  cross_subscription_restore_enabled = var.recovery_vault.cross_subscription_restore_enabled
  public_network_access_enabled      = var.recovery_vault.public_network_access_enabled

  vm_policies         = var.recovery_vault.vm_policies
  sql_workload_policy = try(var.recovery_vault.sql_workload_policy, null)

  tags = var.tags
}
