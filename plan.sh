#!/bin/bash
set -e
###############################################################
# Script Parameters                                           #
###############################################################

while getopts c:e: option
do
    case "${option}"
    in
    c) CLUSTER_NAME=${OPTARG};;
    e) ENVIRONMENT=${OPTARG};;
    esac
done

if [ -z "$CLUSTER_NAME" ]; then
    echo "-c is a required argument - Resource Group Name for storage account"
    exit 1
fi
if [ -z "$ENVIRONMENT" ]; then
    echo "-e is a required argument - Environment (dev, prod)"
    exit 1
fi


###############################################################
# Script Begins                                               #
###############################################################
RESOURCE_GROUP_NAME=${CLUSTER_NAME}${ENVIRONMENT}
STORAGE_ACCOUNT_NAME=${CLUSTER_NAME}${ENVIRONMENT}

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
ARM_TENANT_ID=$(az account show --query tenantId --out tsv)
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

terraform plan -input=false \
 --var tenant=$ARM_TENANT_ID \
 --var subscription=$ARM_SUBSCRIPTION_ID \
 --var prefix=${RESOURCE_GROUP_NAME} \
 -out=$ENVIRONMENT.plan

