resource "azurerm_recovery_services_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  storage_mode_type            = var.storage_mode_type
  cross_region_restore_enabled = var.cross_region_restore_enabled
  soft_delete_enabled          = var.soft_delete_enabled

  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}

# Patch extra properties to match ARM
resource "azapi_update_resource" "vault_patch" {
  type        = "Microsoft.RecoveryServices/vaults@2025-02-01"
  resource_id = azurerm_recovery_services_vault.this.id

  body = {
    properties = {
      securitySettings = {
        softDeleteSettings = {
          softDeleteRetentionPeriodInDays = var.soft_delete_retention_days
          softDeleteState                 = var.soft_delete_enabled ? "Enabled" : "Disabled"
          enhancedSecurityState           = var.enhanced_security_enabled ? "Enabled" : "Disabled"
        }
        sourceScanConfiguration = { state = "Disabled" }
      }
      redundancySettings = {
        standardTierStorageRedundancy = var.storage_mode_type
        crossRegionRestore            = var.cross_region_restore_enabled ? "Enabled" : "Disabled"
      }
      publicNetworkAccess = var.public_network_access_enabled ? "Enabled" : "Disabled"
      restoreSettings = {
        crossSubscriptionRestoreSettings = {
          crossSubscriptionRestoreState = var.cross_subscription_restore_enabled ? "Enabled" : "Disabled"
        }
      }
    }
  }
}

resource "azurerm_backup_policy_vm" "vm" {
  for_each = var.vm_policies

  name                = each.value.name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  timezone            = each.value.timezone

  backup {
    frequency = each.value.backup_frequency
    time      = each.value.backup_time
    weekdays  = each.value.backup_frequency == "Weekly" ? try(each.value.weekdays, null) : null
  }

  retention_daily { count = each.value.retention_daily_count }

  depends_on = [azapi_update_resource.vault_patch]
}