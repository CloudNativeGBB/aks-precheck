# AKS Pre-check

The main purpose of this repo is to put together a script that customers can run to check and see if they have the correct permissions to create AKS clusters. This will help ensure the proper permissions are available when doing a workshop or engagement with a customer.

## Steps

1. Set UPN variable
2. Set RG variable.
3. Update default Azure Subscription
4. Execute Script

## Permission Checks

1. Need Owner on Subscription - Check that user is in the SUBSCRIPTION_OWNERS list. This is needed to be able to correctly create the MC_ resource group created by AKS.
2. Owner on Resource Group - Check that user is in the RG_OWNERS list. This should be Owner if you are Owner on Subscription.
3. Service Principal Validation - Serivce Principal (SP) is only applicable if creating AKS clusters based on SPs. The SERVICEPRINCIPAL_CREATION variable should be populated with SP information. If not, then you don't have the correct permissions.
4. Latest Azure CLI - Check to see that you have the latest version of the Azure CLI.
