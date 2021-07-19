data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "demo_vault" {
  name                        = "Vault-test-0908"
  location                    = azurerm_resource_group.demo.location
  resource_group_name         = azurerm_resource_group.demo.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {


    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Get", "Delete", "Purge", "Recover"
    ]

    storage_permissions = [
      "Get", "List",
    ]

    certificate_permissions = [
      "Get", "List",
    ]

  }
  tags = var.tags
}


resource "azurerm_key_vault_secret" "demo_secret" {
  count        = 3
  name         = "vm-key"
  value        = file("../private")
  key_vault_id = azurerm_key_vault.demo_vault.id
}
