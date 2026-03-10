#!/bin/bash

# Variables
RESOURCE_GROUP="IAM-Project-RG"
LOCATION="eastus"
VNET_NAME="IAM-VNet"
WEB_SUBNET="WebSubnet"
DB_SUBNET="DBSubnet"
WEB_GROUP="WebAdmins"
DB_GROUP="DBAdmins"
WEB_USER="webadmin@favoursylvester1999gmail.onmicrosoft.com"
DB_USER="dbadmin@favoursylvester1999gmail.onmicrosoft.com"

echo "=== Creating Resource Group ==="
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "=== Creating Virtual Network ==="
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix 10.0.0.0/16

echo "=== Creating Web Subnet ==="
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $WEB_SUBNET \
  --address-prefix 10.0.1.0/24

echo "=== Creating DB Subnet ==="
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $DB_SUBNET \
  --address-prefix 10.0.2.0/24

echo "=== Creating Azure AD Groups ==="
az ad group create --display-name $WEB_GROUP --mail-nickname "WebAdmins"
az ad group create --display-name $DB_GROUP --mail-nickname "DBAdmins"

echo "=== Assigning Reader Role to DBAdmins ==="
DB_SUBNET_ID=$(az network vnet subnet show \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $DB_SUBNET \
  --query id -o tsv)

DB_GROUP_ID=$(az ad group show --group $DB_GROUP --query id -o tsv)

az role assignment create \
  --assignee-object-id $DB_GROUP_ID \
  --assignee-principal-type Group \
  --role "Reader" \
  --scope $DB_SUBNET_ID

echo "=== Creating Test Users ==="
az ad user create \
  --display-name "Web Admin User" \
  --user-principal-name $WEB_USER \
  --password "WebAdmin@1234" \
  --force-change-password-next-sign-in false

az ad user create \
  --display-name "DB Admin User" \
  --user-principal-name $DB_USER \
  --password "DBAdmin@1234" \
  --force-change-password-next-sign-in false

echo "=== Adding Users to Groups ==="
WEB_USER_ID=$(az ad user show --id $WEB_USER --query id -o tsv)
DB_USER_ID=$(az ad user show --id $DB_USER --query id -o tsv)

az ad group member add --group $WEB_GROUP --member-id $WEB_USER_ID
az ad group member add --group $DB_GROUP --member-id $DB_USER_ID

echo "=== Validating Role Assignments ==="
az role assignment list --assignee $DB_GROUP_ID --scope $DB_SUBNET_ID -o table

echo "=== DONE! All resources created successfully! ==="
