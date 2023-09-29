
output "polciy_definition_id" {
  value = azurerm_policy_definition.deploy_ama_dcr_association_policy.id
}

output "policy_role_definition_id" {
  value = azurerm_policy_definition.deploy_ama_dcr_association_policy.role_definition_ids
}