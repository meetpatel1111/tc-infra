resource "azurerm_storage_account" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  account_kind             = var.kind

  min_tls_version            = var.min_tls_version
  https_traffic_only_enabled = var.https_only

  shared_access_key_enabled       = var.shared_key_enabled
  default_to_oauth_authentication = var.default_to_oauth

  allow_nested_items_to_be_public = var.allow_public_blob
  access_tier                     = var.access_tier

  tags = var.tags
}

resource "azurerm_storage_account_static_website" "this" {
  count              = var.enable_static_website ? 1 : 0
  storage_account_id = azurerm_storage_account.this.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

resource "azurerm_storage_container" "containers" {
  for_each              = { for c in var.containers : c.name => c }
  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = each.value.access_type
}
