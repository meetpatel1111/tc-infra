output "resource_group" { value = module.rg.name }
output "vm_public_ips" { value = { for k, v in module.public_ip : k => v.ip_address } }
output "cdn_endpoint_fqdn" { value = var.enable_cdn ? module.cdn[0].endpoint_fqdn : null }
