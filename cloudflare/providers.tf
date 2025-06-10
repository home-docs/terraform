# This file configures the necessary providers for our Terraform project.

terraform {
  required_providers {
    # We specify the Cloudflare provider and the version.
    # Using "~>" allows for patch releases (e.g., 5.5.1) but not minor releases (e.g., 5.6.0)
    # which might contain breaking changes.
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.5.0"
    }
  }
}

# Configure the Cloudflare provider with the API token.
# The provider will use this token for all API calls to your Cloudflare account.
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
