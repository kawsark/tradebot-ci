#Provision the Tradebot application infrastructure in Azure and AWS using the tradebot module
module "tradebot" {
  source = "github.com/kawsark/tradebot-terraform-module"

  #Setting Production specific variables
  environment = "production"
  subnet_address_prefix = "10.0.2.0/24"
  domain_name_label = "tradebotui"
  vault_secret_path = "secret/tradebot/prod"
  tradebot-in-queue = "tradebot-in-prod-queue-YP0MHaB"
  public_subnet_1_block = "192.168.0.0/21"
  public_subnet_2_block = "192.168.8.0/21"
  private_subnet_1_block = "192.168.16.0/21"
  private_subnet_2_block = "192.168.24.0/21"

  #Capacity related variables
  azure_vm_qty = 2
  azure_vm_sku = "Standard_DS1_v2"
  instance_size = "t2.micro"
  asg_size_map = { min = 1, desired = 2, max = 2 }

}
  