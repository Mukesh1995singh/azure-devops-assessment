resource_group_name = "rg-devops-assessment-prod"
location            = "Central India"

vnet_name          = "vnet-devops-assessment-prod"
vnet_address_space = ["10.20.0.0/16"]

acr_name = "acrdevopsassessmentprod"
acr_sku  = "Premium"

aks_name               = "aks-devops-assessment-prod"
aks_dns_prefix         = "aks-devops-assessment-prod"
aks_kubernetes_version = "1.33"

aks_node_pool_name = "system"
aks_vm_size        = "Standard_D4s_v5"
aks_node_count     = 2

aks_subnet_name             = "snet-aks-prod"
aks_subnet_address_prefixes = ["10.20.1.0/24"]

appgateway_name                    = "agw-devops-assessment-prod"
appgateway_subnet_name             = "snet-appgateway-prod"
appgateway_subnet_address_prefixes = ["10.20.2.0/24"]
appgateway_public_ip_name          = "pip-appgateway-prod"
appgateway_backend_port            = 80

postgres_server_name                  = "psql-devops-assessment-prod"
postgres_version                      = "16"
postgres_storage_mb                   = 65536
postgres_sku_name                     = "GP_Standard_D2ds_v5"
postgres_zone                         = "1"
postgres_backup_retention_days        = 35
postgres_geo_redundant_backup_enabled = true

postgres_subnet_name             = "snet-postgres-prod"
postgres_subnet_address_prefixes = ["10.20.3.0/24"]

postgres_private_dns_zone_name = "prod.postgres.database.azure.com"
postgres_private_dns_link_name = "private-dns-link-prod"