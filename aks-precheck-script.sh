#!/bin/bash

# Get User Information
UPN=<UPN GOES HERE>
USER_OBJECTID=$(az ad user show --id $UPN --query 'objectId' -o tsv)
echo "UPN: $UPN"
echo "User ObjectID: $USER_OBJECTID"

# Get Subscription ID baed on Current Default
SUBID=$(az account show --query 'id' -o tsv)
echo "Azure Subscription ID: $SUBID"

# Get Resource Group
RG=<RG GOES HERE>
echo "Resource Group: $RG"

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

# Test Service Principal Creation
SERVICEPRINCIPAL_CREATION=$(az ad sp create-for-rbac --skip-assignment --name testAKSServicePrincipal)
echo "Test Service Principal Creation: $SERVICEPRINCIPAL_CREATION"
az ad sp delete --id "http://testAKSServicePrincipal"


# Output Everythign Together
cat <<EOF
UPN: $UPN
User ObjectID: $USER_OBJECTID
Azure Subscription ID: $SUBID
Resource Group: $RG
Azure CLI Version: $AZURE_CLI
Helm Version: $HELM_VERSION
Azure Subscription Owner(s): $SUBSCRIPTION_OWNERS
Azure RG Owner(s): $RG_OWNERS
Test Service Principal Creation: $SERVICEPRINCIPAL_CREATION
EOF
