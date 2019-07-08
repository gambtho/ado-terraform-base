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

ARM_SUBSCRIPTION_ID=$(az account show --query id --out tsv)
ARM_TENANT_ID=$(az account show --query tenantId --out tsv)
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)

terraform plan -input=false \
 --var tenant=$ARM_TENANT_ID \
 --var subscription=$ARM_SUBSCRIPTION_ID \
 --var prefix=${RESOURCE_GROUP_NAME} \
 -out=$ENVIRONMENT.plan

