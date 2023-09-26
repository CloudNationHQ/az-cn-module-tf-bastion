output "bastion" {
  value     = module.bastion.host
  sensitive = true
}

output "subscriptionId" {
  value = module.bastion.subscriptionId
}
