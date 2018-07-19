#Provision the Tradebot UI and DNS infrastructure in Azure
module "tradebotui" {
  source = "github.com/kawsark/tradebot-terraform-module//tradebot-ui-azure?ref=dev"

  #Setting Dev specific variables (module defaults to production)
  environment = "dev"
  location    = "eastus"
  vault_secret_path = "secret/tradebot/dev"
  subnet_address_prefix = "10.0.4.0/24"
  domain_name_label = "tradebotuidev"

  #Capacity related variables (optional)
  azure_vm_qty  = 1
  azure_vm_sku  = "Standard_DS1_v2"
}

#Provision the Tradebot server infrastructure in AWS
module "tradebotserver" {
  source = "github.com/kawsark/tradebot-terraform-module//tradebot-server-aws?ref=dev"

  #Setting Production specific variables (optional - module defaults to production)
  environment            = "dev"
  aws_region             = "us-east-1"
  vault_secret_path = "secret/tradebot/dev"
  tradebot-in-queue = "tradebot-in-dev-queue-YP0MHaB"
  public_subnet_1_block = "192.168.64.0/21"
  public_subnet_2_block = "192.168.72.0/21"
  private_subnet_1_block = "192.168.80.0/21"
  private_subnet_2_block = "192.168.88.0/21"

  #Capacity related variables (optional)
  instance_size = "t2.micro"

  asg_size_map = {
    min = 1
    desired = 1
    max = 1
  }
}
