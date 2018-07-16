#Provision the Tradebot UI and DNS infrastructure in Azure
module "tradebotui" {
  source = "github.com/kawsark/tradebot-terraform-module//tradebot-ui-azure"

  #Setting Production specific variables (optional - module defaults to production)
  environment           = "stage"
  location              = "eastus"
  vault_secret_path     = "secret/tradebot/stage"
  subnet_address_prefix = "10.0.3.0/24"
  domain_name_label     = "tradebotuistage"

  #Capacity related variables (optional)
  azure_vm_qty  = 2
  azure_vm_sku  = "Standard_DS1_v2"
}

#Provision the Tradebot server infrastructure in AWS
module "tradebotserver" {
  source = "github.com/kawsark/tradebot-terraform-module//tradebot-server-aws"

  #Setting Production specific variables (optional - module defaults to production)
  environment            = "stage"
  aws_region             = "us-east-1"
  vault_secret_path     = "secret/tradebot/stage"
  tradebot-in-queue = "tradebot-in-stage-queue-YP0MHaB"
  public_subnet_1_block = "192.168.32.0/21"
  public_subnet_2_block = "192.168.40.0/21"
  private_subnet_1_block = "192.168.48.0/21"
  private_subnet_2_block = "192.168.56.0/21"

  #Capacity related variables (optional)
  instance_size = "t2.micro"

  asg_size_map = {
    min = 1
    desired = 2
    max = 2
  }
}
