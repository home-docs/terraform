# Fetch the details of the zone we are working in.
# This allows us to access attributes like the zone name for use in outputs.
data "cloudflare_zone" "this" {
  zone_id = var.cloudflare_zone_id
}

# This is the main configuration file where we define the resources to create.
# We use a for_each loop to create multiple 'A' records based on the 'a_records' variable.
resource "cloudflare_dns_record" "a_records" {
  for_each = var.a_records
  zone_id  = var.cloudflare_zone_id
  name     = each.key
  content  = each.value.content
  type     = "A"
  ttl      = each.value.ttl
  proxied  = each.value.proxied
}