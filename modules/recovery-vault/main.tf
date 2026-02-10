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

  backup_management_type = "AzureWorkload"
  workload_type          = "SQLDataBase"

  settings {
    time_zone = var.sql_workload_policy.timezone
  }

  sub_protection_policy {
    policy_type = "Full"

    schedule_policy {
      schedule_policy_type   = "SimpleSchedulePolicy"
      schedule_run_frequency = "Daily"
      schedule_run_times     = [var.sql_workload_policy.full_backup_time]
    }

    retention_policy {
      retention_policy_type = "LongTermRetentionPolicy"
      retention_duration {
        count         = var.sql_workload_policy.full_retention_days
        duration_type = "Days"
      }
    }
  }

  sub_protection_policy {
    policy_type = "Log"

    schedule_policy {
      schedule_policy_type       = "LogSchedulePolicy"
      schedule_frequency_in_mins = var.sql_workload_policy.log_backup_frequency_mins
    }

    retention_policy {
      retention_policy_type = "SimpleRetentionPolicy"
      retention_duration {
        count         = var.sql_workload_policy.log_retention_days
        duration_type = "Days"
      }
    }
  }

  depends_on = [azapi_update_resource.vault_patch]
}
