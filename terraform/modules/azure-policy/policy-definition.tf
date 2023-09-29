# Create Azure Policy Definition to deploy Azure Monitoring Agent on Azure Stack HCI and associate Data Collection Rule
resource "azurerm_policy_definition" "deploy_ama_dcr_association_policy" {
  name         = "deploy_ama_dcr_association_policy"
  display_name = "Deploy Azure Monitoring Agent on Azure Stack HCI cluster and associate with Data Collection Rule"
  description  = "Deploy Azure Monitoring Agent on Azure Stack HCI cluster and associate with Data Collection Rule"
  policy_type  = "Custom"
  mode         = "All"
  metadata     = <<METADATA
    {
    "category": "Monitoring"
    }   

METADATA

  policy_rule = <<POLICY_RULE
  {
          "if": {
        "field": "type",
        "equals": "Microsoft.AzureStackHCI/clusters"
      },
      "then": {
        "effect": "deployIfNotExists",
        "details": {
          "type": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions",
          "name": "[concat(field('name'), '/default/AzureMonitorWindowsAgent')]",
          "evaluationDelay": "PT15M",
          "roleDefinitionIds": [
            "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "existenceCondition": {
            "allOf": [
              {
                "field": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions/extensionParameters.type",
                "equals": "AzureMonitorWindowsAgent"
              }
            ]
          },
          "deployment": {
            "properties": {
              "mode": "incremental",
              "template": {
                "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {
                  "clusterName": {
                    "type": "string",
                    "metadata": {
                      "description": "The name of Cluster."
                    }
                  },
                  "dataCollectionRuleId": {
                    "type": "string",
                    "metadata": {
                      "description": "Id of the data collection rule to be associated with the HCI cluster"
                    }
                  },
                  "location": {
                    "type": "string",
                    "metadata": {
                      "description": "location"
                    }
                  }
                },
                "resources": [
                  {
                    "type": "Microsoft.AzureStackHCI/clusters/arcSettings/extensions",
                    "apiVersion": "2022-12-01",
                    "name": "[concat(parameters('clusterName'), '/default/AzureMonitorWindowsAgent')]",
                    "properties": {
                      "extensionParameters": {
                        "publisher": "Microsoft.Azure.Monitor",
                        "type": "AzureMonitorWindowsAgent",
                        "autoUpgradeMinorVersion": false,
                        "enableAutomaticUpgrade": false
                      }
                    }
                  },
                  {
                    "type": "Microsoft.Insights/dataCollectionRuleAssociations",
                    "apiVersion": "2021-09-01-preview",
                    "name": "[concat(parameters('clusterName'), '-DCRA')]",
                    "scope": "[resourceId('Microsoft.AzureStackHCI/clusters', parameters('clusterName'))]",
                    "dependsOn": [
                      "[resourceId('Microsoft.AzureStackHCI/clusters/arcSettings/extensions', parameters('clusterName'), 'default', 'AzureMonitorWindowsAgent')]"
                    ],
                    "properties": {
                      "description": "Association of data collection rule. Deleting this association will break the data collection for this cluster",
                      "dataCollectionRuleId": "[parameters('dataCollectionRuleId')]"
                    }
                  }
                ]
              },
              "parameters": {
                "clusterName": {
                  "value": "[field('Name')]"
                },
                "location": {
                  "value": "[field('location')]"
                },
                "dataCollectionRuleId": {
                  "value": "[parameters('dataCollectionRuleId')]"
                }
              }
            }
          }
        }
      }
    }
POLICY_RULE

  parameters = <<PARAMETERS
{
      "dataCollectionRuleId": {
        "type": "String",
        "metadata": {
          "displayName": "dataCollectionRuleId",
          "description": "Id of the Data Collection Rule to be associated with the HCI cluster"
        }
      }
    }
PARAMETERS
}