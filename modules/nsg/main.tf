resource "azurerm_network_security_group" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "rules" {
  for_each = { for r in var.rules : r.name => r }

  name      = each.value.name
  priority  = each.value.priority
  direction = each.value.direction
  access    = each.value.access
  protocol  = each.value.protocol == "*" ? "*" : title(lower(each.value.protocol))

  source_port_range      = each.value.source_port_range
  destination_port_range = each.value.destination_port_range

  source_address_prefix        = try(each.value.source_address_prefix, null)
  source_address_prefixes      = try(each.value.source_address_prefixes, null)
  destination_address_prefix   = try(each.value.destination_address_prefix, null)
  destination_address_prefixes = try(each.value.destination_address_prefixes, null)

  description = try(each.value.description, null)

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
}
