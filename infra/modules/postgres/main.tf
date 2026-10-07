resource "azurerm_subnet" "postgres" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefixes

  delegation {
    name = "postgresql-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "postgres" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                = var.private_dns_link_name
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id
  virtual_network_id  = var.vnet_id
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  storage_mb = var.storage_mb
  sku_name   = var.sku_name
  zone       = var.zone

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled

  delegated_subnet_id = azurerm_subnet.postgres.id
  private_dns_zone_id = azurerm_private_dns_zone.postgres.id

  public_network_access_enabled = false

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres
  ]
}