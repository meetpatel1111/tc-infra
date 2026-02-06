resource_group_name = "rg-posterscope-tc"

resource_group_location = "eastus"

tags = {
  "app"     = "posterscope-terms"
  "env"     = "dev"
  "version" = "v2.0"
}

vnets = {
  "DAN_Posterscope_TC-vnet" = {
    "location" = "eastus"
    "address_space" = [
      "10.0.3.0/24"
    ]
    "subnets" = {
      "default" = {
        "name"           = "default"
        "address_prefix" = "10.0.3.0/24"
      }
    }
    "tags" = {
      "app" = "posterscope-terms"
      "env" = "dev"
    }
  }
}

public_ips = {
  "IISServer-ip" = {
    "name"              = "IISServer-dev-ip"
    "allocation_method" = "Static"
    "sku"               = "Standard"
    "dns"               = "iisserver-dev.eastus.cloudapp.azure.com"
    "location"          = "eastus"
    "tags" = {
      "app" = "posterscope-terms"
      "env" = "dev"
    }
  }
  "TermsConditions-ip" = {
    "name"              = "TermsConditions-dev-ip"
    "allocation_method" = "Static"
    "sku"               = "Standard"
    "dns"               = "termsconditions-dev.eastus.cloudapp.azure.com"
    "location"          = "eastus"
    "tags" = {
      "app" = "posterscope-terms"
      "env" = "dev"
    }
  }
}

storage_accounts = {
  "danposterscopetcdiag" = {
    "name"               = "pstcdevdiag001"
    "location"           = "eastus"
    "kind"               = "Storage"
    "tier"               = "Standard"
    "replication_type"   = "LRS"
    "min_tls_version"    = "TLS1_2"
    "https_only"         = true
    "allow_public_blob"  = true
    "shared_key_enabled" = true
    "default_to_oauth"   = false
    "tags" = {
      "app" = "posterscope-terms"
    }
    "network_rules" = {
      "default" = {
        "action"   = "Allow"
        "priority" = 100
      }
    }
    "containers" = [
      {
        "name"        = "bootdiagnostics-termscond-052dce4b-4dfe-488e-a32c-c71151576db7"
        "access_type" = "private"
      }
    ]
  }
  "posterscopeterms" = {
    "name"               = "pstcdev001"
    "location"           = "eastus"
    "kind"               = "Storage"
    "tier"               = "Standard"
    "replication_type"   = "LRS"
    "min_tls_version"    = "TLS1_2"
    "https_only"         = true
    "allow_public_blob"  = true
    "shared_key_enabled" = true
    "default_to_oauth"   = false
    "tags" = {
      "app" = "posterscope-terms"
    }
    "network_rules" = {
      "default" = {
        "action"   = "Allow"
        "priority" = 100
      }
    }
    "containers" = [
      {
        "name"        = "bootdiagnostics-iisserver-2b9f7e04-df41-4f52-8be6-164c8ef1cfaf"
        "access_type" = "private"
      }
    ]
  }
  "posterscopetermsdiag" = {
    "name"               = "pstcdevdiag002"
    "location"           = "eastus"
    "kind"               = "Storage"
    "tier"               = "Standard"
    "replication_type"   = "LRS"
    "min_tls_version"    = "TLS1_2"
    "https_only"         = true
    "allow_public_blob"  = true
    "shared_key_enabled" = true
    "default_to_oauth"   = false
    "tags" = {
      "app" = "posterscope-terms"
    }
    "network_rules" = {
      "default" = {
        "action"   = "Allow"
        "priority" = 100
      }
    }
  }
}

nics = {
  "iisserver845" = {
    "location"      = "eastus"
    "subnet_key"    = "DAN_Posterscope_TC-vnet.default"
    "private_ip"    = "10.0.3.4"
    "public_ip_key" = "IISServer-ip"
    "nsg_key"       = "IISServer-nsg"
  }
  "termsconditions215" = {
    "location"      = "eastus"
    "subnet_key"    = "DAN_Posterscope_TC-vnet.default"
    "private_ip"    = "10.0.3.5"
    "public_ip_key" = "TermsConditions-ip"
    "nsg_key"       = "TermsConditions-nsg"
  }
}

windows_vms = {
  "IISServer" = {
    "location"         = "eastus"
    "size"             = "Standard_B2ms"
    "nic_key"          = "iisserver845"
    "admin_username"   = "serveradmin"
    "admin_password"   = "CHANGE_ME_STRONG_PASSWORD"
    "license_type"     = "Windows_Server"
    "enable_boot_diag" = true
    "boot_diag_sa_key" = "danposterscopetcdiag"
    "source_image_reference" = {
      "publisher" = "MicrosoftWindowsServer"
      "offer"     = "WindowsServer"
      "sku"       = "2016-Datacenter"
      "version"   = "latest"
    }
    "os_disk" = {
      "name"                 = "IISServer_OsDisk"
      "caching"              = "ReadWrite"
      "storage_account_type" = "Premium_LRS"
      "disk_size_gb"         = 127
    }
    "vm_extensions" = [
      {
        "name"                 = "enablevmaccess"
        "publisher"            = "Microsoft.Compute"
        "type"                 = "VMAccessAgent"
        "type_handler_version" = "2.0"
        "settings" = {
          "UserName" = "serveradmin"
        }
        "protected_settings"         = {}
        "auto_upgrade_minor_version" = true
      }
    ]
  }
  "TermsConditions" = {
    "location"         = "eastus"
    "size"             = "Standard_B2ms"
    "nic_key"          = "termsconditions215"
    "admin_username"   = "serveradmin"
    "admin_password"   = "CHANGE_ME_STRONG_PASSWORD"
    "license_type"     = "Windows_Server"
    "enable_boot_diag" = true
    "boot_diag_sa_key" = "danposterscopetcdiag"
    "source_image_reference" = {
      "publisher" = "MicrosoftWindowsServer"
      "offer"     = "WindowsServer"
      "sku"       = "2016-Datacenter"
      "version"   = "latest"
    }
    "os_disk" = {
      "name"                 = "TermsConditions_OsDisk"
      "caching"              = "ReadWrite"
      "storage_account_type" = "Premium_LRS"
      "disk_size_gb"         = 127
    }
    "vm_extensions" = []
  }
}

nsgs = {
  "IISServer-nsg" = {
    "location" = "eastus"
    "rules" = [
      {
        "name"                       = "RDP"
        "access"                     = "Allow"
        "direction"                  = "Inbound"
        "priority"                   = 100
        "protocol"                   = "Tcp"
        "source_port_range"          = "*"
        "destination_port_range"     = "3389"
        "source_address_prefix"      = "*"
        "destination_address_prefix" = "*"
      }
    ]
  }
  "TermsConditions-nsg" = {
    "location" = "eastus"
    "rules" = [
      {
        "name"                       = "Port_80"
        "access"                     = "Allow"
        "direction"                  = "Inbound"
        "priority"                   = 100
        "protocol"                   = "Tcp"
        "source_port_range"          = "*"
        "destination_port_range"     = "80"
        "source_address_prefix"      = "*"
        "destination_address_prefix" = "*"
      },
      {
        "name"                       = "RDP"
        "access"                     = "Allow"
        "direction"                  = "Inbound"
        "priority"                   = 110
        "protocol"                   = "Tcp"
        "source_port_range"          = "*"
        "destination_port_range"     = "3389"
        "source_address_prefix"      = "*"
        "destination_address_prefix" = "*"
      }
    ]
  }
}

cdn = {
  "profile_name"  = "posterscope-terms-cdn"
  "endpoint_name" = "posterscope-terms-endpoint"
  "location"      = "eastus"
  "sku"           = "Standard_Microsoft"
  "origin" = {
    "host_name"  = "posterscope-terms.azureedge.net"
    "http_port"  = 80
    "https_port" = 443
  }
  "is_http_allowed"  = true
  "is_https_allowed" = true
  "content_types_to_compress" = [
    "application/eot",
    "application/font",
    "application/font-sfnt",
    "application/javascript",
    "application/json",
    "application/opentype-font",
    "application/otf",
    "application/pkcs7-mime",
    "application/truetype-font",
    "application/vnd.ms-fontobject",
    "application/wasm",
    "application/x-font-opentype",
    "application/x-font-truetype",
    "application/x-font-ttf",
    "application/x-httpd-php",
    "application/x-javascript",
    "application/x-opentype-font",
    "application/x-ttf",
    "application/x-web-app-manifest+json",
    "font/eot",
    "font/ttf",
    "font/otf",
    "font/woff",
    "font/woff2",
    "image/bmp",
    "image/svg+xml",
    "image/x-icon",
    "text/css",
    "text/csv",
    "text/html",
    "text/javascript",
    "text/plain",
    "text/richtext",
    "text/tab-separated-values",
    "text/xml",
    "text/x-script",
    "text/x-component",
    "text/x-java-source"
  ]
  "querystring_caching_behavior" = "IgnoreQueryString"
}

recovery_vault = {
  "name"                               = "vault411"
  "location"                           = "eastus"
  "sku"                                = "Standard"
  "storage_mode_type"                  = "GeoRedundant"
  "cross_region_restore_enabled"       = false
  "soft_delete_enabled"                = true
  "soft_delete_retention_days"         = 14
  "enhanced_security_enabled"          = true
  "cross_subscription_restore_enabled" = true
  "public_network_access_enabled"      = true
  "vm_policies" = {
    "DailyPolicy" = {
      "name"                  = "DailyPolicy-dev"
      "timezone"              = "UTC"
      "backup_frequency"      = "Daily"
      "backup_time"           = "05:00"
      "retention_daily_count" = 180
      "weekdays" = [
        "Sunday"
      ]
    }
    "DefaultPolicy" = {
      "name"                  = "DefaultPolicy-dev"
      "timezone"              = "UTC"
      "backup_frequency"      = "Daily"
      "backup_time"           = "08:00"
      "retention_daily_count" = 30
    }
  }
  "sql_workload_policy" = {
    "name"                      = "HourlyLogBackup"
    "timezone"                  = "UTC"
    "full_backup_time"          = "08:00"
    "full_retention_days"       = 30
    "log_backup_frequency_mins" = 60
    "log_retention_days"        = 30
  }
}
