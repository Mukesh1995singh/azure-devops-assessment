output "vnet_id" {
  value = module.network.vnet_id
}

output "acr_name" {
  value = module.acr.acr_name
}

output "acr_login_server" {
  value = module.acr.acr_login_server
}

output "aks_name" {
  value = module.aks.aks_name
}

output "aks_fqdn" {
  value = module.aks.aks_fqdn
}

output "appgateway_name" {
  value = module.appgateway.appgateway_name
}

output "appgateway_public_ip" {
  value = module.appgateway.public_ip_address
}

output "postgres_server_name" {
  value = module.postgres.postgres_server_name
}

output "postgres_fqdn" {
  value = module.postgres.postgres_fqdn
}