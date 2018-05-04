output "lb_fqdn" {
  value = "${azurerm_public_ip.tradebotlbip.fqdn}"
}

output "cloudflare_fqdn" {
  value = "${cloudflare_record.tradebotdns.hostname}"
}

