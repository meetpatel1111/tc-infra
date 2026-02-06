resource_group_name = "rg-posterscope-tc"

resource_group_location = "eastus"

tags = {
  "app" = "posterscope-terms"
  "env" = "dev"
}

vnets = {
  "DAN_Posterscope_TC-vnet" = {
    "location" = "eastus"
    "address_space" = [
      "10.0.3.0/24"
    ]
    "subnets" = {
      "default" = {
        "address_prefix" = "10.0.3.0/24"
      }
    }
  }
  "DAN_Posterscope_TCvnet588" = {
    "location" = "eastus"
    "address_space" = [
      "10.0.5.0/24"
    ]
    "subnets" = {
      "default" = {
        "address_prefix" = "10.0.5.0/24"
      }
    }
  }
}

nsgs = {
  "IISServer-nsg" = {
    "location" = "eastus"
    "rules" = [
      {
        "name"                       = "RDP"
        "priority"                   = 1001
        "direction"                  = "Inbound"
        "access"                     = "Allow"
        "protocol"                   = "TCP"
        "source_port_range"          = "*"
        "destination_port_range"     = "3389"
        "source_address_prefix"      = "*"
        "destination_address_prefix" = "*"
      },
      {
        "name"                       = "SecurityCenter-JITRule_408244144_37689904940A4FED842EE6DACD612B65"
        "priority"                   = 1000
        "direction"                  = "Inbound"
        "access"                     = "Deny"
        "protocol"                   = "*"
        "source_port_range"          = "*"
        "destination_port_range"     = "3389"
        "source_address_prefix"      = "*"
        "destination_address_prefix" = "10.0.3.4"
        "description"                = "ASC JIT Network Access rule for policy 'default' of VM 'IISServer'."
      },
      {
        "name"                       = "Port_80"
        "priority"                   = 1011
        "direction"                  = "Inbound"
        "access"                     = "Allow"
        "protocol"                   = "*"
        "source_port_range"          = "*"
        "destination_port_range"     = "80"
        "source_address_prefix"      = "*"
        "destination_address_prefix" = "*"
        "description"                = "Allow Port 80 access to sites"
      }
    ]
  }
  "TermsConditions-nsg" = {
    "location" = "eastus"
    "rules" = [
      {
        "name"                   = "RDP"
        "priority"               = 300
        "direction"              = "Inbound"
        "access"                 = "Allow"
        "protocol"               = "TCP"
        "source_port_range"      = "*"
        "destination_port_range" = "3389"
        "source_address_prefixes" = [
          "100.8.98.21",
          "35.146.170.96",
          "71.172.162.246",
          "108.35.16.33",
          "165.225.220.77",
          "100.8.120.125",
          "100.8.109.86",
          "58.84.60.217",
          "73.196.28.104",
          "103.147.161.162",
          "123.252.146.166",
          "117.217.116.146",
          "13.68.216.197"
        ]
        "destination_address_prefix" = "*"
      },
      {
        "name"                       = "Port_80"
        "priority"                   = 310
        "direction"                  = "Inbound"
        "access"                     = "Allow"
        "protocol"                   = "*"
        "source_port_range"          = "*"
        "destination_port_range"     = "80"
        "source_address_prefix"      = "*"
        "destination_address_prefix" = "*"
      }
    ]
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
    "name"               = "danposterscopetcdiag-dev"
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
    "name"               = "posterscopeterms-dev"
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
    "name"               = "posterscopeterms-dev-diag"
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
    "boot_diag_sa_key" = "danposterscopetcdiag-dev"
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
    "boot_diag_sa_key" = "danposterscopetcdiag-dev"
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

cdn = {
  "profile_name"  = "posterscopeterms"
  "location"      = "westus"
  "sku"           = "Standard_Microsoft"
  "endpoint_name" = "posterscopeterms"
  "origin" = {
    "host_name"          = "posterscopeterms.blob.core.windows.net"
    "origin_host_header" = "posterscopeterms.blob.core.windows.net"
    "http_port"          = 80
    "https_port"         = 443
  }
  "is_http_allowed"     = true
  "is_https_allowed"    = true
  "compression_enabled" = true
  "content_types_to_compress" = [
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
      "name"                  = "DailyPolicy"
      "timezone"              = "UTC"
      "backup_frequency"      = "Daily"
      "backup_time"           = "05:00"
      "retention_daily_count" = 180
      "weekdays" = [
        "Sunday"
      ]
    }
    "DefaultPolicy" = {
      "name"                  = "DefaultPolicy"
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
