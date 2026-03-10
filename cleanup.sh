#!/bin/bash

# Variables
RESOURCE_GROUP="IAM-Project-RG"
VNET_NAME="IAM-VNet"
DB_SUBNET="DBSubnet"
WEB_GROUP="WebAdmins"
DB_GROUP="DBAdmins"
WEB_USER="webadmin@favoursylvester1999gmail.onmicrosoft.com"
DB_USER="dbadmin@favoursylvester1999gmail.onmicrosoft.com"

echo "=== Removing Users from Groups ==="
WEB_USER_ID=$(az ad user show --id $WEB_USER --query id -o tsv)
DB_USER_ID=$(az ad user show --id $DB_USER --query id -o tsv)

az ad group member remove --group $WEB_GROUP --member-id $WEB_USER_ID
az ad group member remove --group $DB_GROUP --member-id $DB_USER_ID

echo "=== Revoking Reader Role from DBAdmins ==="
DB_SUBNET_ID=$(az network vnet subnet show \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $DB_SUBNET \
  --query id -o tsv)

DB_GROUP_ID=$(az ad group show --group $DB_GROUP --query id -o tsv)

az role assignment delete \
  --assignee $DB_GROUP_ID \
  --role "Reader" \
  --scope $DB_SUBNET_ID

echo "=== Deleting Test Users ==="
az ad user delete --id $WEB_USER
az ad user delete --id $DB_USER

echo "=== Deleting AD Groups ==="
az ad group delete --group $WEB_GROUP
az ad group delete --group $DB_GROUP

echo "=== Deleting Resource Group ==="
az group delete --name $RESOURCE_GROUP --yes --no-wait

echo "=== Cleanup Complete! ==="
