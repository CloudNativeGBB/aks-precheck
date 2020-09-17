#!/bin/bash

# Get User Information
UPN=$1
USER_OBJECTID=$(az ad user show --id $UPN --query 'objectId' -o tsv)
echo "UPN: $UPN"
echo "User ObjectID: $USER_OBJECTID"

# Get Subscription ID based on Current Default
SUBID=$(az account show --query 'id' -o tsv)
echo "Azure Subscription ID: $SUBID"

# Get Resource Group
RG=$2
echo "Resource Group: $RG"

# Set Location
LOC=eastus
echo "Location: $LOC"

# Get Azure CLI Version
AZURE_CLI=$(az version --query '"azure-cli"' -o tsv)
echo "Azure CLI Version: $AZURE_CLI"

# Get HELM Version
HELM_VERSION=$(helm version --short)
echo "Helm Version: $HELM_VERSION"

# Check Azure Subscription Ownership
SUBSCRIPTION_OWNERS=$(az role assignment list --role "Owner" --scope "/subscriptions/${SUBID}" --include-inherited --assignee $USER_OBJECTID --include-inherited)
echo "Azure Subscription Owner(s): $SUBSCRIPTION_OWNERS"
# Check Azure RG Ownership
RG_OWNERS=$(az role assignment list --role "Owner" --scope "/subscriptions/${SUBID}/resourceGroups/${RG}" --include-inherited --assignee $USER_OBJECTID --include-inherited)
echo "Azure RG Owner(s): $RG_OWNERS"

# Check Resource Provider Registrations
COMPUTE_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.Compute'].{Name:namespace,State:registrationState}")
NETWORK_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.Network'].{Name:namespace,State:registrationState}")
STORAGE_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.Storage'].{Name:namespace,State:registrationState}")
MSI_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.ManagedIdentity'].{Name:namespace,State:registrationState}")
OMS_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.OperationsManagement'].{Name:namespace,State:registrationState}")
AKS_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.ContainerService'].{Name:namespace,State:registrationState}")
ACR_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.ContainerRegistry'].{Name:namespace,State:registrationState}")
echo "$COMPUTE_REGISTRATION"
echo "$NETWORK_REGISTRATION"
echo "$STORAGE_REGISTRATION"
echo "$MSI_REGISTRATION"
echo "$OMS_REGISTRATION"
echo "$AKS_REGISTRATION"
echo "$ACR_REGISTRATION"
# Register Missing Providers
# az provider register --namespace Microsoft.Compute
# az provider register --namespace Microsoft.Network
# az provider register --namespace Microsoft.Storage
# az provider register --namespace Microsoft.ManagedIdentity
# az provider register --namespace Microsoft.OperationsManagement
# az provider register --namespace Microsoft.ContainerService
# az provider register --namespace Microsoft.ContainerRegistry
# Check Quotas (Specifically Compute)
REGIONAL_CPU_QUOTA=$(az vm list-usage -l $LOC -o table --query "[?localName == 'Total Regional vCPUs'].{Name:localName,CurrentValue:currentValue,Limit:limit}")
echo "$REGIONAL_CPU_QUOTA"

# Test Service Principal Creation
SERVICEPRINCIPAL_CREATION=$(az ad sp create-for-rbac --skip-assignment --name testAKSServicePrincipal)
echo "Test Service Principal Creation: $SERVICEPRINCIPAL_CREATION"
az ad sp delete --id "http://testAKSServicePrincipal"


# Output Everything Together
cat <<EOF
UPN: $UPN
User ObjectID: $USER_OBJECTID
Azure Subscription ID: $SUBID
Resource Group: $RG
Location: $LOC
Azure CLI Version: $AZURE_CLI
Helm Version: $HELM_VERSION
Azure Subscription Owner(s): $SUBSCRIPTION_OWNERS
Azure RG Owner(s): $RG_OWNERS
$COMPUTE_REGISTRATION

$NETWORK_REGISTRATION

$STORAGE_REGISTRATION

$MSI_REGISTRATION

$OMS_REGISTRATION

$AKS_REGISTRATION

$ACR_REGISTRATION

$REGIONAL_CPU_QUOTA

Test Service Principal Creation: $SERVICEPRINCIPAL_CREATION
EOF
