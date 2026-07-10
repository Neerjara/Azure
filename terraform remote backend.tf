# Resource Group az commands to create remote backend
az group create \
    --name nm_group \
    --location centralindia

# Storage Account
az storage account create \
    --name myterraformstate12345 \
    --resource-group nm_group \
    --sku Standard_LRS

# Blob Container
az storage container create \
    --name tfstate \
    --account-name myterraformstate12345

