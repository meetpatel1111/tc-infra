resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [var.nic_id]
  license_type          = var.license_type

  identity { type = "SystemAssigned" }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  os_disk {
    name                 = var.os_disk.name
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diag && var.boot_diagnostics_storage_uri != null ? [1] : []
    content { storage_account_uri = var.boot_diagnostics_storage_uri }
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "ext" {
  for_each = { for e in var.vm_extensions : e.name => e }

  name                       = each.value.name
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = each.value.publisher
  type                       = each.value.type
  type_handler_version       = each.value.type_handler_version
  auto_upgrade_minor_version = try(each.value.auto_upgrade_minor_version, true)

  settings           = jsonencode(each.value.settings)
  protected_settings = each.value.protected_settings == null ? null : jsonencode(each.value.protected_settings)
}
