# This file defines the outputs that will be displayed after a successful 'terraform apply'.
# Outputs are useful for viewing information about the resources you've created.

output "a_record_hostnames" {
  description = "A map of the hostnames of the created 'A' records."
  # The 'hostname' attribute is not available directly on the resource.
  # We construct it by combining the record's name and the zone name from the data source.
  value       = { for k, v in cloudflare_dns_record.a_records : k => "${v.name}.${data.cloudflare_zone.this.name}" }
}
output "a_record_ids" {
  description = "A map of the IDs of the created 'A' records."
  value       = { for k, v in cloudflare_dns_record.a_records : k => v.id }
}
