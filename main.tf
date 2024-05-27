resource "azurerm_key_vault" "keyvaultblock" {
    for_each = var.keyvaultvariable
  name                        = each.value.keyvaultname
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.datablockclientconfig.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.datablockclientconfig.tenant_id
    object_id = data.azurerm_client_config.datablockclientconfig.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "secretusernameblock" {
    for_each = var.keyvaultvariable
  name         = "adminuser"
  value        = "adminuser"
  key_vault_id = azurerm_key_vault.keyvaultblock[each.key].id
}

resource "azurerm_key_vault_secret" "secretpasswordblock" {
    for_each = var.keyvaultvariable
  name         = "password"
  value        = "password"
  key_vault_id = azurerm_key_vault.keyvaultblock[each.key].id
}