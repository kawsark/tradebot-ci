#Provision the Tradebot application infrastructure in Azure and AWS using the tradebot module
module "tradebot" {
  source = "github.com/kawsark/tradebot-terraform-module"

  #Setting Dev specific variables
  environment = "dev"
  subnet_address_prefix = "10.0.4.0/24"
  domain_name_label = "tradebotuidev"
  vault_secret_path = "secret/tradebot/dev"
  tradebot-in-queue = "tradebot-in-dev-queue-YP0MHaB"
  public_subnet_1_block = "192.168.64.0/21"
  public_subnet_2_block = "192.168.72.0/21"
  private_subnet_1_block = "192.168.80.0/21"
  private_subnet_2_block = "192.168.88.0/21"

  #Capacity related variables
  azure_vm_qty = 1
  azure_vm_sku = "Standard_DS1_v2"
  instance_size = "t2.micro"
  asg_size_map = { min = 1, desired = 1, max = 1 }

}
  