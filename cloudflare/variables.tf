# This file declares all the variables needed for our configuration.
# The actual values for these variables are provided in the terraform.tfvars file,
# which is kept private and not committed to version control.

variable "cloudflare_api_token" {
  description = "The Cloudflare API token. This is used to authenticate with the Cloudflare API."
  type        = string
  sensitive   = true # Marks the variable as sensitive, so Terraform won't show its value in logs.
}

variable "cloudflare_account_id" {
  description = "The Cloudflare account ID. You can find this in your Cloudflare dashboard."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Zone ID of the domain you want to manage. You can find this on the overview page for your domain in the Cloudflare dashboard."
  type        = string
}

variable "a_records" {
  description = "A map of 'A' records to create. The key is the subdomain, and the value is an object containing the IP address and other optional settings."
  type = map(object({
    content = string
    proxied = optional(bool, false)
    ttl     = optional(number, 1) # Default TTL is 1 second, which means 'automatic' in Cloudflare terms.
  }))
  default = {}
}