#Provision the Tradebot application infrastructure in Azure and AWS using the tradebot module
module "tradebot" {
  source = "github.com/kawsark/tradebot-terraform-module"

  #Setting Staging specific variables
  environment = "stage"
  subnet_address_prefix = "10.0.3.0/24"
  domain_name_label = "tradebotuistage"
  vault_secret_path = "secret/tradebot/stage"
  tradebot-in-queue = "tradebot-in-stage-queue-YP0MHaB"
  public_subnet_1_block = "192.168.32.0/21"
  public_subnet_2_block = "192.168.40.0/21"
  private_subnet_1_block = "192.168.48.0/21"
  private_subnet_2_block = "192.168.56.0/21"

  #Capacity related variables
  azure_vm_qty = 2
  azure_vm_sku = "Standard_DS1_v2"
  instance_size = "t2.micro"
  asg_size_map = { min = 1, desired = 2, max = 2 }

}
  