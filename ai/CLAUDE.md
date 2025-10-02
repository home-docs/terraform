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
- External records (proxied=true): homeassistant, immich, jellyfin, jellyseerr, karakeep, obsidianlivesync, ollama, overseerr, plex, rw (rwmarkable), vaultwarden
- All external records point to 15.235.186.122

### Portainer Module
- Deploys Docker stacks via Portainer API
- Active stacks: gluetun (VPN), karakeep (note-taking), kometa (media management), obsidian_livesync (sync), open_webui (AI interface), rwmarkable (checklist/notes), watchtower (container updates)
- Commented stacks: calibre_web, chrome, drawio, vaultwarden, semaphore, workout_cool, silverbullet
- Uses Docker Compose templates with variable substitution
- Variables include Docker user settings, paths, and service-specific secrets
- rwmarkable: Self-hosted checklist and note-taking app, accessible at rw.ketwork.in, port 5230

#### Important: Docker Compose Template Variables
- Template files (*.yml.tpl) use Terraform's `templatefile()` function for variable substitution
- **CRITICAL**: Use single `${variable}` syntax in .tpl files, NOT double `$${variable}`
- Double `$$` escapes the variable, causing Portainer to receive literal variable names instead of values
- Example issue: `$${docker_user_puid}` passes the string "${docker_user_puid}" instead of "1001"
- Always verify template substitution in `terraform plan` output before applying

#### Ansible Playbook for Host Preparation
- An Ansible playbook exists on the Caddy server for preparing Docker hosts
- Located at: (path on Caddy server for portainer setup playbook)
- Creates necessary directories with proper ownership (PUID/PGID 1001:1001)
- If encountering permission errors with new stacks, run this playbook to ensure directories exist with correct permissions
- Playbook creates directory structure: /docker/{app_name}/{data,config,cache}

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