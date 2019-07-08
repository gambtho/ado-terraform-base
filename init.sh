#!/bin/bash
set -e
###############################################################
# Script Parameters                                           #
###############################################################

while getopts a:e:g: option
do
    case "${option}"
    in
    a) STORAGE_ACCOUNT_NAME=${OPTARG};;
    e) ENVIRONMENT=${OPTARG};;
    g) RESOURCE_GROUP_NAME=${OPTARG};;
    esac
done

if [ -z "$RESOURCE_GROUP_NAME" ]; then
    echo "-g is a required argument - Resource Group Name for storage account"
    exit 1
fi
if [ -z "$STORAGE_ACCOUNT_NAME" ]; then
    echo "-a is a required argument - Storage account name"
    exit 1
fi
if [ -z "$ENVIRONMENT" ]; then
    echo "-e is a required argument - Environment (dev, prod)"
    exit 1
fi


###############################################################
# Script Begins                                               #
###############################################################

set +e # errors don't matter for a bit

# Create resource group
if [ $(az group exists -n $RESOURCE_GROUP_NAME -o tsv) = false ]
then
    az group create --name $RESOURCE_GROUP_NAME --location eastus2
else
    echo "Resource Group $RESOURCE_GROUP_NAME already exists"
fi

# Create storage account
az storage account show -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME > /dev/null
if [ $? -eq 0 ]
then
    echo "Storage account $STORAGE_ACCOUNT_NAME in resource group $RESOURCE_GROUP_NAME already exists"
else
    az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
fi

set -e # errors matter again

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

# Create blob container
az storage container create --name $ENVIRONMENT --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
ARM_TENANT_ID=$(az account show --query tenantId --out tsv)


terraform init -upgrade -input=false \
    -backend-config="access_key=$ACCOUNT_KEY" \
    -backend-config="resource_group_name=$RESOURCE_GROUP_NAME" \
    -backend-config="storage_account_name=$STORAGE_ACCOUNT_NAME" \
    -backend-config="container_name=$ENVIRONMENT"

