module "network" {
  source = "../../modules/network"

  vnet_name           = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
}

module "acr" {
  source = "../../modules/acr"

  acr_name            = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
}

module "aks" {
  source = "../../modules/aks"

  aks_name            = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_dns_prefix

  kubernetes_version = var.aks_kubernetes_version
  node_pool_name     = var.aks_node_pool_name
  vm_size            = var.aks_vm_size
  node_count         = var.aks_node_count

  vnet_name               = var.vnet_name
  subnet_name             = var.aks_subnet_name
  subnet_address_prefixes = var.aks_subnet_address_prefixes

  depends_on = [module.network]
}

module "appgateway" {
  source = "../../modules/appgateway"

  appgateway_name         = var.appgateway_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  vnet_name               = var.vnet_name
  subnet_name             = var.appgateway_subnet_name
  subnet_address_prefixes = var.appgateway_subnet_address_prefixes

  public_ip_name = var.appgateway_public_ip_name
  backend_port   = var.appgateway_backend_port

  depends_on = [module.network]
}

module "postgres" {
  source = "../../modules/postgres"

  server_name            = var.postgres_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  postgres_version       = var.postgres_version
  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  storage_mb                   = var.postgres_storage_mb
  sku_name                     = var.postgres_sku_name
  zone                         = var.postgres_zone
  backup_retention_days        = var.postgres_backup_retention_days
  geo_redundant_backup_enabled = var.postgres_geo_redundant_backup_enabled

  vnet_name               = var.vnet_name
  vnet_id                 = module.network.vnet_id
  subnet_name             = var.postgres_subnet_name
  subnet_address_prefixes = var.postgres_subnet_address_prefixes

  private_dns_zone_name = var.postgres_private_dns_zone_name
  private_dns_link_name = var.postgres_private_dns_link_name

  depends_on = [module.network]
}