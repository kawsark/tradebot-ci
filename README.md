# tradebot-webui-ci
**Tradebot Web UI**: Terraform templates and Ansible playbooks for provisioning in Azure.
- The Terraform templates use an AWS S3 remote state store configured in `backend.tf`.
- Deployment: After `terraform apply` completes, please update `/etc/ansible/hosts` file with Azure VM public IP address, then run: `ansible-playbook deploy_tradebotwebui.yml`.
- The application can be accessed via Load Balancer fqdn address output from Terraform.
- Note: a corresponding Tradebot server application must be running for bot execution.


