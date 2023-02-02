output "publicip" {
    value = azurerm_public_ip.pip_demo.ip_address
}

output "username" {
    value = azurerm_linux_virtual_machine.jenkins_virtualmachine.admin_username
}

output "password" {
    sensitive = true
    value = azurerm_linux_virtual_machine.jenkins_virtualmachine.admin_password
}