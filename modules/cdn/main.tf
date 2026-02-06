resource "azurerm_cdn_profile" "this" {
  name                = var.profile_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_cdn_endpoint" "this" {
  name                = var.endpoint_name
  resource_group_name = var.resource_group_name
  profile_name        = azurerm_cdn_profile.this.name
  location            = var.location

  origin {
    name       = "origin"
    host_name  = var.origin.host_name
    http_port  = var.origin.http_port
    https_port = var.origin.https_port
  }

  is_http_allowed               = var.is_http_allowed
  is_https_allowed              = var.is_https_allowed
  content_types_to_compress     = var.content_types_to_compress
  querystring_caching_behaviour = var.querystring_caching_behavior
  tags                          = var.tags
}
