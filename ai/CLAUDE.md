# Claude Context

This file contains project-specific information for Claude to understand the Terraform infrastructure project.

## Project Structure

This is a multi-module Terraform project for managing infrastructure and container deployments:

```
/home/home/terraform/
├── ai/                     # AI-related configurations and Claude context
│   ├── CLAUDE.md          # This file
│   └── .claude/           # Claude command templates and configurations
├── cloudflare/            # Cloudflare DNS management
│   ├── main.tf            # DNS A records configuration
│   ├── variables.tf       # Variable definitions
│   ├── providers.tf       # Provider configuration
│   └── outputs.tf         # Output definitions
├── portainer/             # Docker container management via Portainer
│   ├── main.tf            # Stack deployments (gluetun, karakeep, kometa, etc.)
│   ├── variables.tf       # Variable definitions for all services
│   └── compose-files/     # Docker Compose templates (.yml.tpl files)
└── proxmox/               # Proxmox infrastructure (empty)
```

## Modules Overview

### Cloudflare Module
- Manages DNS A records using a map-based configuration
- Supports proxied/non-proxied records with configurable TTL
- Variables include API token, account ID, zone ID, and A records map

### Portainer Module
- Deploys Docker stacks via Portainer API
- Active stacks: gluetun (VPN), karakeep (note-taking), kometa (media management), obsidian_livesync (sync), open_webui (AI interface), watchtower (container updates)
- Commented stacks: calibre_web, chrome, drawio, vaultwarden, semaphore, workout_cool, silverbullet
- Uses Docker Compose templates with variable substitution
- Variables include Docker user settings, paths, and service-specific secrets

## Development Commands

```bash
# Terraform commands (run from specific module directory)
terraform init          # Initialize Terraform
terraform plan          # Plan changes
terraform apply          # Apply changes
terraform destroy        # Destroy resources
terraform validate       # Validate configuration
terraform fmt            # Format code
```

## Security Notes

- `.tfvars` files are git-ignored and contain sensitive data
- Sensitive variables are marked appropriately in variable definitions
- API keys, passwords, and tokens are properly handled as sensitive