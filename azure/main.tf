provider "azurerm" {

  features {}
}


resource "azurerm_resource_group" "azresource" {
  name     = "fraxses-resources"
  location = var.region
}

resource "azurerm_kubernetes_cluster" "azcluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.azresource.location
  resource_group_name = azurerm_resource_group.azresource.name
  dns_prefix          = "fraxsesaks"

  default_node_pool {
    name       = "fraxses"
    node_count = var.min_size
    min_count  = var.min_size
    max_count  = var.max_size
    vm_size    = var.processor
    enable_auto_scaling  = true
  }

  identity {
    type = "SystemAssigned"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.azcluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.azcluster.kube_config_raw
}
