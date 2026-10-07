variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "acr_name" {
  type = string
}

variable "acr_sku" {
  type = string
}

variable "aks_name" {
  type = string
}

variable "aks_dns_prefix" {
  type = string
}

variable "aks_kubernetes_version" {
  type = string
}

variable "aks_node_pool_name" {
  type = string
}

variable "aks_vm_size" {
  type = string
}

variable "aks_node_count" {
  type = number
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_subnet_address_prefixes" {
  type = list(string)
}

variable "appgateway_name" {
  type = string
}

variable "appgateway_subnet_name" {
  type = string
}

variable "appgateway_subnet_address_prefixes" {
  type = list(string)
}

variable "appgateway_public_ip_name" {
  type = string
}

variable "appgateway_backend_port" {
  type = number
}

variable "postgres_server_name" {
  type = string
}

variable "postgres_version" {
  type = string
}

variable "postgres_admin_username" {
  type      = string
  sensitive = true
}

variable "postgres_admin_password" {
  type      = string
  sensitive = true
}

variable "postgres_storage_mb" {
  type = number
}

variable "postgres_sku_name" {
  type = string
}

variable "postgres_zone" {
  type = string
}

variable "postgres_backup_retention_days" {
  type = number
}

variable "postgres_geo_redundant_backup_enabled" {
  type = bool
}

variable "postgres_subnet_name" {
  type = string
}

variable "postgres_subnet_address_prefixes" {
  type = list(string)
}

variable "postgres_private_dns_zone_name" {
  type = string
}

variable "postgres_private_dns_link_name" {
  type = string
}

variable "postgres_deletion_protection_enabled" {
  type    = bool
  default = false
}