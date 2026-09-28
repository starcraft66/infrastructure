output "blackbox_monitoring_client_id" {
  value = module.pocketid_oidc_k8s.blackbox_monitoring_client_id
}

output "blackbox_monitoring_client_secret" {
  value     = module.pocketid_oidc_k8s.blackbox_monitoring_client_secret
  sensitive = true
}
