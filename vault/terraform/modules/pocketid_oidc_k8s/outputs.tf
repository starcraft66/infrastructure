output "blackbox_monitoring_client_id" {
  value = pocketid_client.blackbox_monitoring.id
}

output "blackbox_monitoring_client_secret" {
  value     = pocketid_client.blackbox_monitoring.client_secret
  sensitive = true
}
