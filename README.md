# tradebot-ci
### Provisions the tradebot application. There are 3 key environments being provisioned: Server infrastructure in AWS, Web Interface in Azure and DNS records in CloudFlare.

#### Instructions for use:
Please setup the dependencies below and run: `terraform get`, `terraform plan` and `terraform apply`. To remove the environment, use: `terraform destroy`.
- ** Dependencies: ** There is a dependency on Vault to obtain secrets. AWS and Azure credentials are assumed to be available via Environment variables, and / or `az`, `aws` CLI configuration.
- ** Module: ** Provisioning code, outputs and default variables are stored in the tradebot-terraform-module Git repo.
- ** Outputs: ** To view outputs, please run the `terraform output -module=tradebot`
- ** Variables: ** All variables are optional, recommended variables are set in the main.tf file for each branch
- ** Remote state: ** An S3 backend is configured in the `backend.tf` file, please adjust bucket details appropriately. Alternatively this file can be removed if local state is ok.

#### Instructions for use:
**CloudFlare DNS**:
- Provisions the tradebotui and tradebot DNS records under a specified root domain name

**Tradebot Web UI**: Terraform templates and Ansible playbooks for provisioning in Azure.
- The Terraform templates use an AWS S3 remote state store configured in `backend.tf`.
- Deployment: After `terraform apply` completes, please run the `deploy_tradebot.sh` script from ansible/ directory
- The application can be accessed via Load Balancer fqdn address output from Terraform.
- Note: a corresponding Tradebot server application must be running for bot execution.

**Tradebot server**: Terraform templates for provisioning the Cryptocurrency Tradebot server application in AWS
- Application Deployment: `terraform apply` will provision a tradebot server AMI which contains a pre-deployed tradebot server application.
- In future versions we will move away from AMI towards bootstrapping application post instance initialization.