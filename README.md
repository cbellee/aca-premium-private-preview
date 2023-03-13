# Azure Container Apps Private Preview UDR / Az Firewall / Application Gateway example

### Pre-requisites
- Azure subscription (whitelisted for you subscription)
- Azure CLI
- Bash shell (WSL2)
- Public wild-card TLS certificate in .PFX format

### Deployment
- create /.env file at the repo root containing the following environment variables
  - PUBLIC_CERT_PASSWORD='<your PFX certificate secret>'
  - ADMIN_GROUP_OBJECT_ID=<your AAD AKS admin group name>
- create a directory named 'certs' in the repo root 
  - add the TLS wild-card PFX certificate to the /certs directory
- change current working directory to the repo root
- run deploy.sh in the Bash shell
  - $ ./deploy.sh
