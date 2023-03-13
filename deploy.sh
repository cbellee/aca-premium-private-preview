resourceGroup='aca-udr-rg'
location="northcentralus"
image='mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
DOMAIN_NAME='kainiindustries.net' # replace with your public domain name
PUBLIC_PFX_CERT_FILE="./certs/star.${DOMAIN_NAME}.bundle.pfx"
PUBLIC_PFX_CERT_NAME='public-certificate-pfx'
PUBLIC_DNS_ZONE_RESOURCE_GROUP='external-dns-zones-rg'

# load vars from /.env file. 
# the following env vars should be defined within the file
#
# PUBLIC_CERT_PASSWORD='<your PFX certificate secret>'
# ADMIN_GROUP_OBJECT_ID=<your AAD AKS admin group name>

source ./.env

# create resource group
az group create --name $resourceGroup --location $location

# deploy key vault
az deployment group create \
  --resource-group $resourceGroup \
  --name kv-deployment \
  --template-file ./modules/keyVault.bicep \
  --parameters keyVaultAdminObjectId=$ADMIN_GROUP_OBJECT_ID \
  --parameters location=$location

# get keyvault name
KV_NAME=$(az deployment group show --resource-group $resourceGroup --name kv-deployment --query 'properties.outputs.keyVaultName.value' -o tsv)

# upload public tls certificate to Key Vault
PUBLIC_CERT_PROPS=$(az keyvault certificate import --vault-name $KV_NAME -n $PUBLIC_PFX_CERT_NAME -f $PUBLIC_PFX_CERT_FILE --password $PUBLIC_CERT_PASSWORD)
PUBLIC_CERT_SID=$(echo $PUBLIC_CERT_PROPS | jq .sid -r)

# deploy resources
az deployment group create \
--resource-group $resourceGroup \
--name 'aca-udr-deployment' \
--template-file ./azuredeploy.bicep \
--parameters ./azuredeploy.parameters.json \
--parameters imageName=$image \
--parameters location=$location \
--parameters tlsCertSecretId="$PUBLIC_CERT_SID" \
--parameters domain=$DOMAIN_NAME \
--parameters keyVaultName=$KV_NAME \
--parameters publicDnsZoneResourceGroup=$PUBLIC_DNS_ZONE_RESOURCE_GROUP
