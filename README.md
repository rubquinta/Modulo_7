# Modulo_7
Codigos de ejercicios de Modulo 7: archivos tf de terraform y también ansible. Se debe clonar repo a nivel local.

1. Para levantar cm de azure 
    a. Agregar provider.tf por tu cuenta con la data necesaria desde azure: 

        provider "azurerm" {
            subscription_id = " "
            client_id = " "
            client_secret = " "
            tenant_id = " "
            features {}
        }

      b. Ubicarse en Carpeta: vm azure
      c. Ejecutar: terraform init
      d. Ejecutar: terraform plan -out plan.out
      e. Verificar que esté bien de sintaxis.
      f. Terraform apply
  
2. Para levantar  cluster kubernetes. 
    a. Agregar provider.tf por tu cuenta con la data necesaria desde azure: 

    provider "azurerm" {
        subscription_id = " "
        client_id = " "
        client_secret = " "
        tenant_id = " "
        features {}
    }
    b. Ubicarse en Carpeta: cluster de Kubernetes
    c. Ejecutar: terraform init
    d. Ejecutar: terraform plan 
    e. Verificar que esté bien de sintaxis.
    f. Ejecutar: terraform apply "plan.out"
    
    
 3. Para levantar VM's (master - Nodo) con Vagrant, y ansible ya instalado:
      
      1. Ubicarse en carpeta master:
        CMD: vagrant up
      2. Ubicarse en carpeta nodo:
        CMD: vagrant up
        
   Nota: ya tiene configurado el inventario para el conectar siempre al nodo. 
   El playbook para instalar jenkins está en master se llama: playbookjenkins.yml
   
   Para verlo ejecutar "vim playbookjenkins.yml" desde master: 
   vagrant@master:~$ vim playbookjenkins.yml
