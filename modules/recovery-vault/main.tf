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

resource "azurerm_backup_policy_vm_workload" "sql" {
  count = var.sql_workload_policy == null ? 0 : 1

  name                = var.sql_workload_policy.name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  workload_type       = "SQLDataBase"

  settings { time_zone = var.sql_workload_policy.timezone }

  protection_policy {
    policy_type = "Full"
    backup {
      frequency = "Daily"
      time      = var.sql_workload_policy.full_backup_time
      weekdays  = null
    }
    retention_daily { count = var.sql_workload_policy.full_retention_days }
  }

  protection_policy {
    policy_type = "Log"
    backup {
      frequency_in_minutes = var.sql_workload_policy.log_backup_frequency_mins
      weekdays             = null
    }
    retention_daily { count = var.sql_workload_policy.log_retention_days }
  }

  depends_on = [azapi_update_resource.vault_patch]
}

# Replication settings resources from ARM
resource "azapi_resource" "replication_alert" {
  type       = "Microsoft.RecoveryServices/vaults/replicationAlertSettings@2025-02-01"
  name       = "defaultAlertSetting"
  parent_id  = azurerm_recovery_services_vault.this.id
  body       = { properties = { sendToOwners = "DoNotSend", customEmailAddresses = [] } }
  depends_on = [azapi_update_resource.vault_patch]
}

resource "azapi_resource" "replication_vault_settings" {
  type       = "Microsoft.RecoveryServices/vaults/replicationVaultSettings@2025-02-01"
  name       = "default"
  parent_id  = azurerm_recovery_services_vault.this.id
  body       = { properties = {} }
  depends_on = [azapi_update_resource.vault_patch]
}
