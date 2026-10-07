output "appgateway_id" {
  value = azurerm_application_gateway.appgateway.id
}

output "appgateway_name" {
  value = azurerm_application_gateway.appgateway.name
}

output "public_ip_id" {
  value = azurerm_public_ip.appgateway.id
}

output "public_ip_address" {
  value = azurerm_public_ip.appgateway.ip_address
}

output "subnet_id" {
  value = azurerm_subnet.appgateway.id
}