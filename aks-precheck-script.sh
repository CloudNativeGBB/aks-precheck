#!/bin/bash


# exit when any command fails
set -e


# COLORS
NC="\033[0m" # No Color
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
YELLOW="$(tput setaf 3)"
MAGENTA="$(tput setaf 5)"
TXTLBL="$(tput setaf 6)"
GREY="$(tput setaf 8)"
WHITE="$(tput setaf 255)"
BWHITE="$(tput setab 255)"
MSFT_ORANGE="$(tput setaf 202)"
MSFT_GREEN="$(tput setaf 118)"
MSFT_BLUE="$(tput setaf 004)"
MSFT_YELLOW="$(tput setaf 003)"
BOLD="$(tput bold)"
NORMAL="$(tput sgr0)"
CHECK="\xE2\x9C\x94"
BLOCKSET="\xE2\x96\x93\xE2\x96\x93\xE2\x96\x93\xE2\x96\x93"
TL="\xE2\x95\x94"
BL="\xE2\x95\x9A"
TR="\xE2\x95\x97"
BR="\xE2\x95\x9D"
VERT="\xE2\x95\x91"
HORZ="\xE2\x95\x90"
ATOM="\xE2\x9A\x9B"
LBSPACE="                                                                        "
HORZLINE=""

FAILMSG=""
# keep track of the last executed command
# trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# trap ' ' DEBUG
# echo an error message before exiting
# trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT
done=false
cleanup() { if $done; then echo -e "${FAILMSG}"; fi; }
trap cleanup EXIT



for i in {1..72}
do
   HORZLINE="$HORZLINE$HORZ"
done


# MSFT LOGO
echo -e "\n${WHITE}${TL}${HORZLINE}${TR}${NC}"
echo -e "${WHITE}${VERT}${LBSPACE}${VERT}${NC}"
echo -e "${WHITE}${VERT}${NC}   ${MSFT_ORANGE}${BLOCKSET}${NC}${MSFT_GREEN}${BLOCKSET}${NC}                                                             ${WHITE}${VERT}${NC}"
echo -e "${WHITE}${VERT}${NC}   ${MSFT_ORANGE}${BLOCKSET}${NC}${MSFT_GREEN}${BLOCKSET}${NC}               ${GREEN}Azure Kubernetes Service ${NC}                     ${WHITE}${VERT}${NC}"
echo -e "${WHITE}${VERT}${NC}   ${MSFT_BLUE}${BLOCKSET}${NC}${MSFT_YELLOW}${BLOCKSET}${NC}                   ${WHITE}PreCheck Script${NC}                           ${WHITE}${VERT}${NC}"
echo -e "${WHITE}${VERT}${NC}   ${MSFT_BLUE}${BLOCKSET}${NC}${MSFT_YELLOW}${BLOCKSET}${NC}                                                             ${WHITE}${VERT}${NC}"
echo -e "${WHITE}${VERT}${LBSPACE}${VERT}${NC}"
echo -e "${WHITE}${BL}${HORZLINE}${BR}${NC}\n"

                                                                              
# Get the operating system
# TODO : Add logic for installs executables that are missing
OS=$(uname)
if [ "$OS" == "Linux" ]
then
    source /etc/os-release
fi

# Basic executable requirements
# Azure CLI
AZ=""
if [ -z $(type -fp az) ]
then
    FAILMSG="   Failure: \n\n   ===> ${RED}MISSING AZURE CLI${NC}"
    done=true
    exit 1
else
    AZ=$(az version -o json | jq '.["azure-cli"]' | tr -d \")
    if [[ "$AZ" == "" ]]
    then
        AZ="Your version is out of date, please update.  https://aka.ms/azure-cli"
    fi
fi

# Helm
HELM=""
if [ -z $(type -fp helm) ]
then
    FAILMSG="   Failure: \n\n   ===> ${RED}MISSING HELM${NC}"
    done=true
    exit 1
else
    HELM=$(helm version --short)
fi

# If the have the az cli - read the azureProfile.json
# .subscriptions[] | select(.isDefault==true).user.name

AZSUBINFO=$(cat ~/.azure/azureProfile.json | jq '.subscriptions[] | select(.isDefault==true) | {SubscriptionID: .id, SubscriptionName: .name, User: .user.name}')
UPN=$(echo $AZSUBINFO | jq '.User' | tr -d \")
SUBID=$(echo $AZSUBINFO | jq '.SubscriptionID' | tr -d \")
SUBNAME=$(echo $AZSUBINFO | jq '.SubscriptionName' | tr -d \")
USEROBJ=$(az ad user show --id "${UPN}" --query 'objectId' -o tsv)

echo -e "   [${GREEN}${BOLD}${CHECK}${NORMAL}${NC}]${NC} ${TXTLBL}Operating System      ${NC}$OS - ${PRETTY_NAME}"
echo -e "   [${GREEN}${BOLD}${CHECK}${NORMAL}${NC}]${NC} ${TXTLBL}Power Capacity        ${NC}1.21 Gigawatts"
echo -e "   [${GREEN}${BOLD}${CHECK}${NORMAL}${NC}]${NC} ${TXTLBL}Azure CLI             ${NC}${AZ}"
echo -e "   [${GREEN}${BOLD}${CHECK}${NORMAL}${NC}]${NC} ${TXTLBL}Helm                  ${NC}${HELM}"
echo -e "   [${GREEN}${BOLD}${CHECK}${NORMAL}${NC}]${NC} ${TXTLBL}Azure UPN             ${NC}${UPN}"
echo -e "   [${GREEN}${BOLD}${CHECK}${NORMAL}${NC}]${NC} ${TXTLBL}User Object ID        ${NC}${USEROBJ}"
echo -e "   [${GREEN}${BOLD}${CHECK}${NORMAL}${NC}]${NC} ${TXTLBL}Subscription ID       ${NC}${SUBID}"
echo -e "   [${GREEN}${BOLD}${CHECK}${NORMAL}${NC}]${NC} ${TXTLBL}Subscription Name     ${NC}${SUBNAME}"




# Resource Group Info
RG=""

# # Get Subscription ID based on Current Default
# SUBID=$(az account show --query 'id' -o tsv)
# echo "Azure Subscription ID: $SUBID"

# Get Resource Group

# echo "Resource Group: $RG"

# # Set Location
# LOC=eastus
# echo "Location: $LOC"

# # Get Azure CLI Version
# AZURE_CLI=$(az version --query '"azure-cli"' -o tsv)
# echo "Azure CLI Version: $AZURE_CLI"

# # Get HELM Version
# HELM_VERSION=$(helm version --short)
# echo "Helm Version: $HELM_VERSION"

# # Check Azure Subscription Ownership
# SUBSCRIPTION_OWNERS=$(az role assignment list --role "Owner" --scope "/subscriptions/${SUBID}" --include-inherited --assignee $USEROBJ --include-inherited)
# echo "Azure Subscription Owner(s): $SUBSCRIPTION_OWNERS"
# # Check Azure RG Ownership
# RG_OWNERS=$(az role assignment list --role "Owner" --scope "/subscriptions/${SUBID}/resourceGroups/${RG}" --include-inherited --assignee $USEROBJ --include-inherited)
# echo "Azure RG Owner(s): $RG_OWNERS"

# # Check Resource Provider Registrations
# COMPUTE_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.Compute'].{Name:namespace,State:registrationState}")
# NETWORK_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.Network'].{Name:namespace,State:registrationState}")
# STORAGE_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.Storage'].{Name:namespace,State:registrationState}")
# MSI_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.ManagedIdentity'].{Name:namespace,State:registrationState}")
# OMS_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.OperationsManagement'].{Name:namespace,State:registrationState}")
# AKS_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.ContainerService'].{Name:namespace,State:registrationState}")
# ACR_REGISTRATION=$(az provider list -o table --query "[?namespace == 'Microsoft.ContainerRegistry'].{Name:namespace,State:registrationState}")
# echo "$COMPUTE_REGISTRATION"
# echo "$NETWORK_REGISTRATION"
# echo "$STORAGE_REGISTRATION"
# echo "$MSI_REGISTRATION"
# echo "$OMS_REGISTRATION"
# echo "$AKS_REGISTRATION"
# echo "$ACR_REGISTRATION"
# # Register Missing Providers
# # az provider register --namespace Microsoft.Compute
# # az provider register --namespace Microsoft.Network
# # az provider register --namespace Microsoft.Storage
# # az provider register --namespace Microsoft.ManagedIdentity
# # az provider register --namespace Microsoft.OperationsManagement
# # az provider register --namespace Microsoft.ContainerService
# # az provider register --namespace Microsoft.ContainerRegistry
# # Check Quotas (Specifically Compute)
# REGIONAL_CPU_QUOTA=$(az vm list-usage -l $LOC -o table --query "[?localName == 'Total Regional vCPUs'].{Name:localName,CurrentValue:currentValue,Limit:limit}")
# echo "$REGIONAL_CPU_QUOTA"

# Test Service Principal Creation
# SERVICEPRINCIPAL_CREATION=$(az ad sp create-for-rbac --skip-assignment --name testAKSServicePrincipal)
# echo "Test Service Principal Creation: $SERVICEPRINCIPAL_CREATION"
# az ad sp delete --id "http://testAKSServicePrincipal"



# Output Everything Together
# cat <<EOF
# UPN: $UPN
# User ObjectID: $USER_OBJECTID
# Azure Subscription ID: $SUBID
# Resource Group: $RG
# Location: $LOC
# Azure CLI Version: $AZURE_CLI
# Helm Version: $HELM_VERSION
# Azure Subscription Owner(s): $SUBSCRIPTION_OWNERS
# Azure RG Owner(s): $RG_OWNERS
# $COMPUTE_REGISTRATION

# $NETWORK_REGISTRATION

# $STORAGE_REGISTRATION

# $MSI_REGISTRATION

# $OMS_REGISTRATION

# $AKS_REGISTRATION

# $ACR_REGISTRATION

# $REGIONAL_CPU_QUOTA

# Test Service Principal Creation: $SERVICEPRINCIPAL_CREATION
# EOF
