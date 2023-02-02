resource "azurerm_resource_group" "rg-ask-demo" {
    name = var.name
    location = var.location

    tags = {
        "group" = var.group
    }
}

resource "azurerm_public_ip" "publicip" {
    name = "public-ip"
    resource_group_name = azurerm_resource_group.rg-ask-demo.name
    location = azurerm_resource_group.rg-ask-demo.location
    allocation_method = "Static"

    tags = {
        "group" = var.group
    }
}

resource "azurerm_virtual_network" "vnet-aks-demo" {
    name= "my-vnet"
    address_space = ["12.0.0.0/16"]
    location = azurerm_resource_group.rg-ask-demo.location
    resource_group_name = azurerm_resource_group.rg-ask-demo.name
}

resource "azurerm_subnet" "subnet-ask-demo" {
    name = "internal"
    resource_group_name = azurerm_resource_group.rg-ask-demo.name
    virtual_network_name = azurerm_virtual_network.vnet-aks-demo.name
    address_prefixes = ["12.0.0.0/20"]
}

resource "azurerm_network_interface" "networkinterface" {
    name = "networkinterface"
    location = azurerm_resource_group.rg-ask-demo.location
    resource_group_name = azurerm_resource_group.rg-ask-demo.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.subnet-ask-demo.id
        private_ip_address_allocation = "Dynamic"  
        public_ip_address_id = azurerm_public_ip.publicip.id

    }
}

resource "azurerm_container_registry" "acr-ask-demo" {
    name = "acrdemorubenq"
    resource_group_name = azurerm_resource_group.rg-ask-demo.name
    location = azurerm_resource_group.rg-ask-demo.location
    sku = "Basic"
    admin_enabled = true
}

resource "azurerm_kubernetes_cluster" "rg-ask-demo" {
    name = "aks-demo-sec1"
    resource_group_name = azurerm_resource_group.rg-ask-demo.name
    location = azurerm_resource_group.rg-ask-demo.location
    dns_prefix = "aks1"
    kubernetes_version = "1.24.6"

    default_node_pool {
        name = "default"
        node_count = 2
        vm_size = "Standard_D2_v2"
        vnet_subnet_id = azurerm_subnet.subnet-ask-demo.id
        enable_auto_scaling = true
        max_count = 3
        min_count = 1
        max_pods = 80
    }

    service_principal {
        client_id = "ac1b3170-6b58-43ca-b9c2-8c1f0f2f69c6"
        client_secret = "cEf8Q~byLtV4AV_T3eXBygVdfcaKat9wYuQ0_cI5"
    }

    network_profile {
        network_plugin = "azure"
        network_policy = "azure"
    }

    role_based_access_control_enabled = true       

}

resource "azurerm_kubernetes_cluster_node_pool" "k8s_node_pool_adicional" {
    name                  = "internal"
    kubernetes_cluster_id = azurerm_kubernetes_cluster.rg-ask-demo.id
    vm_size               = "Standard_DS2_v2"
    enable_auto_scaling = true
    tags = {
        Environment = "adicional"
    }
}










