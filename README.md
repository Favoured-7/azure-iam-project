# Azure IAM Roles and Secure Access Automation

## Project Overview
This project automates secure identity and access controls using Azure CLI and Bash scripting on Microsoft Azure.

## Tools Used
- Microsoft Azure
- Azure CLI
- Bash Scripting
- Microsoft Entra ID

## Resources Created
- Resource Group: IAM-Project-RG
- Virtual Network: IAM-VNet
- WebSubnet: 10.0.1.0/24
- DBSubnet: 10.0.2.0/24
- Groups: WebAdmins, DBAdmins
- Users: webadmin, dbadmin
- Role: Reader assigned to DBAdmins on DBSubnet

## How to Run

### Setup
```bash
chmod +x setup-iam.sh
./setup-iam.sh
```

### Cleanup (BONUS)
```bash
chmod +x cleanup.sh
./cleanup.sh
```

## GitHub Repository
https://github.com/Favoured-7/azure-iam-project
