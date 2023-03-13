# Azure Container Apps Private Preview for UDR + Az Firewall + Application Gateway example

### Pre-requisites
- Azure subscription (whitelisted for you subscription)
- Azure CLI
- Bash shell (WSL2)
- Public wild-card TLS certificate in .PFX format

### Deployment
- Create /.env file at the repo root containing the following environment variables
  - PUBLIC_CERT_PASSWORD='<your PFX certificate secret>'
  - ADMIN_GROUP_OBJECT_ID=<your AAD AKS admin group name>
- Create a directory named 'certs' in the repo root 
  - add the TLS wild-card PFX certificate to the /certs directory
- Change current working directory to the repo root
- Run deploy.sh in the Bash shell
  - $ ./deploy.sh
