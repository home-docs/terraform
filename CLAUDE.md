# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Terraform Commands
- `terraform init` - Initialize Terraform modules and providers
- `terraform plan` - Show planned changes before applying
- `terraform apply` - Apply Terraform configuration changes
- `terraform fmt` - Format Terraform files (all code must be fmt compliant)
- `terraform validate` - Validate Terraform configuration syntax
- `terraform destroy` - Destroy managed infrastructure (use with extreme caution)

### Required Terraform Workflow
**IMPORTANT**: Always follow this sequence when making changes:

1. **Format**: Run `terraform fmt` after making any changes to `.tf` files
2. **Validate**: Run `terraform validate` to check configuration syntax  
3. **Plan**: Run `terraform plan` to review what changes will be applied
4. **Apply**: Only run `terraform apply` after confirming the plan is correct

Never skip validation and planning steps before applying changes.


## Architecture Overview

This is a multi-provider Terraform configuration organized into modular components:

### Module Structure
- **cloudflare/** - DNS record management using Cloudflare provider
  - Bulk DNS record creation using `for_each` loops
  - Zone data retrieval and A record management
- **portainer/** - Docker stack deployment via Portainer provider  
  - Docker Compose template files in `compose-files/` directory
  - Stack deployment using `templatefile()` function with variable substitution
  - Active stacks: gluetun, karakeep, kometa, obsidian_livesync, open_webui, watchtower
- **proxmox/** - Proxmox VM management (structure present but no active configurations)

### Key Patterns
- Provider configurations isolated to module directories
- Template-driven Docker Compose file generation
- Extensive use of variables for environment customization
- Many resources commented out for selective deployment

## Terraform Coding Standards

### Code Style
- Use Terraform 1.6+ HCL syntax
- All code must be `terraform fmt` compliant
- Use snake_case for variable names and outputs
- Avoid hardcoding values - prefer variables or locals
- Use `terraform.tfvars` for non-sensitive defaults
- Keep provider versions pinned and explicit

### File Organization
- Keep `.tf` files focused by purpose (variables.tf, outputs.tf, main.tf)
- Organize each provider into its own module folder
- Use workspaces for environment separation (dev, staging, prod)

### Resource Management
- Use `lifecycle` rules for resources that are costly to recreate
- Use `prevent_destroy = true` for critical resources
- Use `depends_on` for resources with implicit dependencies
- Add comments above each resource explaining purpose

### Security Requirements
- Never commit secrets to the repo
- Mark sensitive variables with `sensitive = true`
- Reference API keys and passwords from environment variables or secret managers
- Use least-privilege credentials for all providers
- Store sensitive credentials in external secrets managers

### Provider-Specific Guidelines

#### Cloudflare
- Use official `cloudflare` provider with pinned version
- Tag resources with `managed_by = "terraform"`
- Configure DNS records with appropriate TTLs (default to `1` for dev)
- Use `for_each` for bulk DNS record creation
- Use `cloudflare_ruleset` instead of deprecated `firewall_rule`

#### Portainer  
- Pin `portainer` provider version explicitly
- Configure endpoints via Terraform instead of manual UI
- Use Terraform to manage stacks and app templates
- Prefer stack deployment from Git repositories for version control
- Store Portainer admin credentials in secrets manager

#### Proxmox
- Use `Telmate/proxmox` provider with pinned version
- Keep VM templates separate from VM instance definitions  
- Use `cloud-init` templates for VM provisioning
- Store sensitive Proxmox credentials in environment variables
- Always set explicit `target_node` and `vmid`
- Use variables for CPU, RAM, and disk sizing instead of fixed numbers

### Documentation Requirements
- Document all input variables with descriptions and types
- Include module-level `README.md` with usage instructions
- Use examples folder for sample module usage

## Git Workflow

**IMPORTANT**: Never make git commits directly via automation. When asked to commit changes:
1. Remind the user to review changes in VS Code first
2. Let the user stage and commit manually through VS Code interface or command line
3. This ensures proper review and control over git history