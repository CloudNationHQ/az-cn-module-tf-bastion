output "host" {
  value = azurerm_bastion_host.bastion
}

output "subscriptionId" {
  value = data.azurerm_subscription.current.subscription_id
}
