# Monitoring Azure Stack HCI Clusters with Azure Monitor at Scale via Azure Policy and Terraform

This repository contains a Terraform module that can be used to configure Azure Policy to enable Azure Monitor for Azure Stack HCI clusters at scale. The module creates a custom policy definition, policy assignment, and a data collection rule. The policy definition identifies Azure Stack HCI clusters where insights have not been configured, and for those Azure Stack HCI clusters, it installs the Azure Monitoring Agent(AMA) extension, and associates the cluster with the created data collection rule, which enables insights for the cluster.

## Prerequisites

- Azure CLI
- Terraform CLI
- Azure subscription
- Azure Log Analytics Workspace
- Azure Stack HCI Cluster (Azure Stack HCI cluster should be registered with Azure and Arc-enabled. If you registered your cluster on or after June 15, 2021, this happens by default. Otherwise, you must enable Azure Arc integration.)
- User Assigned Managed Identity to be used by the policy assignment
  
## Run Terraform Module

1. Clone the repository to your local machine
2. Update the [policy.tfvars](./Terraform/policy.tfvars) file with the required values
3. Az login to the Azure subscription where the Azure Stack HCI cluster is registered
4. Set the subscription context

   ```bash
   az account set --subscription <subscription_id>
   ```

5. Run the following commands to initialize the terraform module and apply the changes

   ```bash
   cd terraform
   terraform init
   terraform plan -var-file=policy.tfvars
   terraform apply -var-file=policy.tfvars
   ```

## Resources created by the terraform module

- [Data Collection Rule](./Terraform/modules/azure-policy/data-collection.tf#L10): The [Data Collection Rule](https://learn.microsoft.com/en-us/azure-stack/hci/manage/monitor-hci-single?tabs=22h2-and-later#data-collection-rules) with [performance counters](https://learn.microsoft.com/en-us/azure-stack/hci/manage/monitor-hci-single?tabs=22h2-and-later#performance-counters) is created in the specified Log Analytics Workspace's resource group, and associated with the configured log analytics workspace. The data collection rule is set up with all performance counter and event log names, which are required for HCI cluster monitoring

- [Policy Definition](./Terraform/modules/azure-policy/policy-definition.tf): This custom policy definition identifies HCI clusters where insights have not been configured, and for those HCI clusters, it installs the Azure Monitoring Agent(AMA) extension, and associates the cluster with the created data collection rule, which enables insights for the cluster.
  
- [Policy Assignment](./Terraform/modules/azure-policy/policy-assignment.tf#L6): This policy assignment assigns the policy definition scoped to the subscription where the Azure Stack HCI cluster is deployed.
