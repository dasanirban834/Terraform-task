output "random_id" {
  value = random_id.demo_id.hex
}

output "network_interface_details" {
  value = zipmap(azurerm_network_interface.demo_inc.*.name, azurerm_network_interface.demo_inc.*.private_ip_addresses)
}

output "load_balancer_publicip_address" {
  value = azurerm_lb_rule.demo_rule.id
}

output "vault_uri" {
  value = azurerm_key_vault.demo_vault.vault_uri
}

output "bastion_dns_name" {
  value = azurerm_bastion_host.bastion_host.dns_name
}
