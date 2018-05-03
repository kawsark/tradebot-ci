variable "azure_vm_sku" {
	 default = "Standard_DS1_v2"
}

variable "azure_vm_qty" {
	 default = 1
}

variable "location" {
	 default = "eastus"
}

variable "environment" {
	 default = "Dev"
}

variable "application" {
	 default = "Tradebot"
}

variable "vnet_address_space" {
	 default =   "10.0.0.0/16"
}

variable "subnet_address_prefix" {
	 default = "10.0.4.0/24"
}

variable "domain_name_label" {
	 default = "tradebotdev"
}

variable "vault_secret_path" {
	 default = "secret/tradebot/dev"
}
