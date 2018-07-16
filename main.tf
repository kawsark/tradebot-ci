#Provision the Tradebot UI and DNS infrastructure in Azure
module "tradebotui" {
  source = "github.com/kawsark/tradebot-terraform-module//tradebot-ui-azure"

  #Setting Production specific variables (optional - module defaults to production)
  environment           = "production"
  location              = "eastus"
  vault_secret_path     = "secret/tradebot/prod"
  subnet_address_prefix = "10.0.2.0/24"
  domain_name_label     = "tradebotui"

  #Capacity related variables (optional)
  azure_vm_qty  = 2
  azure_vm_sku  = "Standard_DS1_v2"
}

#Provision the Tradebot server infrastructure in AWS
module "tradebotserver" {
  source = "github.com/kawsark/tradebot-terraform-module//tradebot-server-aws"

  #Setting Production specific variables (optional - module defaults to production)
  environment            = "production"
  aws_region             = "us-east-1"
  vault_secret_path      = "secret/tradebot/prod"
  tradebot-in-queue      = "tradebot-in-prod-queue-YP0MHaB"
  public_subnet_1_block  = "192.168.0.0/21"
  public_subnet_2_block  = "192.168.8.0/21"
  private_subnet_1_block = "192.168.16.0/21"
  private_subnet_2_block = "192.168.24.0/21"

  #Capacity related variables (optional)
  instance_size = "t2.micro"

  asg_size_map = {
    min = 1
    desired = 2
    max = 2
  }
}
