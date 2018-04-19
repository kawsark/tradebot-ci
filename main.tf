# provider "azurerm" is in account variables

# Create the resource group
resource "azurerm_resource_group" "tradebotresourcegroup" {
  name     = "tradebotresourcegroup"
  location = "${var.location}"

  tags {
    environment = "Dev"
    application = "Tradebot"
  }
}

# Create a VNET
resource "azurerm_virtual_network" "tradebotvnet" {
  name                = "tradebotvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tradebotresourcegroup.name}"

  tags {
    environment = "Dev"
    application = "Tradebot"
  }
}

# Create a Subnet
resource "azurerm_subnet" "tradebotsubnet1" {
  name                 = "tradebotsubnet1"
  resource_group_name  = "${azurerm_resource_group.tradebotresourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.tradebotvnet.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create a public IP address
resource "azurerm_public_ip" "tradebotpublicip" {
  name                         = "tradebotpublicip${count.index}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.tradebotresourcegroup.name}"
  public_ip_address_allocation = "dynamic"
  count                        = 2

  tags {
    environment = "Dev"
    application = "Tradebot"
    description = "IP address for tradebot Web UI server"
  }
}

#Create a network security group
resource "azurerm_network_security_group" "tradebotpublicipnsg" {
  name                = "tradebotpublicipnsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tradebotresourcegroup.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-Tomcat"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "Dev"
    application = "Tradebot"
    description = "NSG with for tradebot Web UI application"
  }
}

#Create a vNIC x2
resource "azurerm_network_interface" "tradebotwebuivnic" {
  name                = "tradebotwebuivnic${count.index}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.tradebotresourcegroup.name}"
  count               = 2

  ip_configuration {
    name                          = "myNicConfiguration${count.index}"
    subnet_id                     = "${azurerm_subnet.tradebotsubnet1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.tradebotpublicip.*.id, count.index)}"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.backend_pool.id}"]
  }

  tags {
    environment = "Dev"
    application = "Tradebot"
  }
}

#Create some random text
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.tradebotresourcegroup.name}"
  }

  byte_length = 8
}

#Create a storage account
resource "azurerm_storage_account" "tradebotstorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.tradebotresourcegroup.name}"
  location                 = "${var.location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags {
    environment = "Dev"
    application = "Tradebot"
  }
}


#Definitions for HA configuration
#Create an availability set
resource "azurerm_availability_set" "avset" {
  name                         = "tradebotwebuiavset"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.tradebotresourcegroup.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_public_ip" "tradebotlbip" {
  name                         = "tradebotlbip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.tradebotresourcegroup.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "tradebotdomain"
 }

resource "azurerm_lb" "tradebotlb" {
  resource_group_name = "${azurerm_resource_group.tradebotresourcegroup.name}"
  name                = "tradebotlb"
  location            = "${var.location}"

  frontend_ip_configuration {
      name                 = "LoadBalancerFrontEnd"
      public_ip_address_id = "${azurerm_public_ip.tradebotlbip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  resource_group_name = "${azurerm_resource_group.tradebotresourcegroup.name}"
  loadbalancer_id     = "${azurerm_lb.tradebotlb.id}"
  name                = "BackendPool1"
}


resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = "${azurerm_resource_group.tradebotresourcegroup.name}"
    loadbalancer_id                = "${azurerm_lb.tradebotlb.id}"
    name                           = "LBRule"
    protocol                       = "tcp"
    frontend_port                  = 80
    backend_port                   = 8080
    frontend_ip_configuration_name = "LoadBalancerFrontEnd"
    enable_floating_ip             = false
    backend_address_pool_id        = "${azurerm_lb_backend_address_pool.backend_pool.id}"
    idle_timeout_in_minutes        = 5
    probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
    depends_on                     = ["azurerm_lb_probe.lb_probe"]
}

resource "azurerm_lb_probe" "lb_probe" {
    resource_group_name = "${azurerm_resource_group.tradebotresourcegroup.name}"
    loadbalancer_id     = "${azurerm_lb.tradebotlb.id}"
    name                = "tcpProbe"
    protocol            = "tcp"
    port                = 8080
    interval_in_seconds = 5
    number_of_probes    = 2
}




#Create the Virtual Machine
resource "azurerm_virtual_machine" "tradebotwebuivm" {
  name                  = "tradebotwebuivm${count.index}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.tradebotresourcegroup.name}"
  availability_set_id   = "${azurerm_availability_set.avset.id}"
  network_interface_ids = ["${element(azurerm_network_interface.tradebotwebuivnic.*.id, count.index)}"]
  vm_size               = "Standard_DS1_v2"
  count                 = 2

  storage_os_disk {
    name              = "myOsDisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "tradebotwebuivm"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${var.ssh_id_rsa_pub}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.tradebotstorageaccount.primary_blob_endpoint}"
  }

  tags {
    environment = "Dev"
    application = "Tradebot"
    description = "Tradebot Web UI server"
  }

}
