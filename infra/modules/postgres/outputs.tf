output "postgres_server_id" {
  value = azurerm_postgresql_flexible_server.postgres.id
}

output "postgres_server_name" {
  value = azurerm_postgresql_flexible_server.postgres.name
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "postgres_subnet_id" {
  value = azurerm_subnet.postgres.id
}