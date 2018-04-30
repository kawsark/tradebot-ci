variable "location" {
	 default = "eastus"
}

variable "environment" {
	 default = "Production"
}

variable "application" {
	 default = "Tradebot"
}

variable "vnet_address_space" {
	 default =   "10.0.0.0/16"
}

variable "subnet_address_prefix" {
	 default = "10.0.2.0/24"
}

variable "domain_name_label" {
	 default = "tradebot"
}

variable "vault_secret_path" {
	 default = "secret/tradebot/prod"
}
