resource "azurerm_resource_group" "rg_demo" {
    name = var.name
    location = var.location
    tags = {
        diplomado = "DipS1"
        Modulo = 7
    }
}


resource "azurerm_public_ip" "pip_demo"{
    name = "public-ip"
    resource_group_name = azurerm_resource_group.rg_demo.name
    location = azurerm_resource_group.rg_demo.location
    allocation_method = "Static"

    tags = {
        diplomado = "TareaEjercicioTf"
    }
}

resource "azurerm_virtual_network" "vnet_demo" {
    name= "my-vnet"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.rg_demo.location
    resource_group_name = azurerm_resource_group.rg_demo.name
}

resource "azurerm_subnet" "subnet" {
    name = "internal"
    resource_group_name = azurerm_resource_group.rg_demo.name
    virtual_network_name = azurerm_virtual_network.vnet_demo.name
    address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "networkinterface" {
    name = "networkinterface"
    location = azurerm_resource_group.rg_demo.location
    resource_group_name = azurerm_resource_group.rg_demo.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"  
        public_ip_address_id = azurerm_public_ip.pip_demo.id

    }
}

resource "azurerm_linux_virtual_machine" "jenkins_virtualmachine" {
name = "jenkins-machine"
resource_group_name = azurerm_resource_group.rg_demo.name
location = azurerm_resource_group.rg_demo.location
size = "Standard_B1s"
//admin_username      = "adminuser"
network_interface_ids = [
    azurerm_network_interface.networkinterface.id,
]
/*
admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/rq.pem")
}*/

os_disk {
    name= "jenkins-os-disk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
}

source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
}

computer_name = "hostname"
admin_username = "testadmin"
admin_password = "Demo-1234"

disable_password_authentication = false
}