resource_group_name = "rg-devops-assessment-dev"
location            = "Central India"

vnet_name          = "vnet-devops-assessment-dev"
vnet_address_space = ["10.10.0.0/16"]

acr_name = "acrdevopsassessmentdev"
acr_sku  = "Basic"

aks_name               = "aks-devops-assessment-dev"
aks_dns_prefix         = "aks-devops-assessment-dev"
aks_kubernetes_version = "1.33"

aks_node_pool_name = "system"
aks_vm_size        = "Standard_D2s_v5"
aks_node_count     = 1

aks_subnet_name             = "snet-aks-dev"
aks_subnet_address_prefixes = ["10.10.1.0/24"]

appgateway_name                    = "agw-devops-assessment-dev"
appgateway_subnet_name             = "snet-appgateway-dev"
appgateway_subnet_address_prefixes = ["10.10.2.0/24"]
appgateway_public_ip_name          = "pip-appgateway-dev"
appgateway_backend_port            = 80

postgres_server_name                  = "psql-devops-assessment-dev"
postgres_version                      = "16"
postgres_storage_mb                   = 32768
postgres_sku_name                     = "B_Standard_B1ms"
postgres_zone                         = "1"
postgres_backup_retention_days        = 7
postgres_geo_redundant_backup_enabled = false

postgres_subnet_name             = "snet-postgres-dev"
postgres_subnet_address_prefixes = ["10.10.3.0/24"]

postgres_private_dns_zone_name = "dev.postgres.database.azure.com"
postgres_private_dns_link_name = "private-dns-link-dev"