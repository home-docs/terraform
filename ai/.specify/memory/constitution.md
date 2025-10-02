<!--
SYNC IMPACT REPORT
==================
Version Change: [TEMPLATE] → 1.0.0
Type: INITIAL (First ratification from template)

Modified Principles:
- NEW: I. Infrastructure as Code First
- NEW: II. Module Isolation
- NEW: III. Security by Default
- NEW: IV. Documentation Currency
- NEW: V. State Management Discipline

Added Sections:
- Core Principles (5 principles defined)
- Technology Standards (Terraform-specific constraints)
- Change Management (workflow and review requirements)
- Governance (constitution management rules)

Removed Sections: None (template initialization)

Templates Requiring Updates:
- ✅ plan-template.md: Constitution Check section aligns with new principles
- ✅ spec-template.md: Requirements structure compatible with infrastructure features
- ✅ tasks-template.md: Task categorization supports Terraform workflow

Follow-up TODOs: None - All placeholders resolved
-->

# Terraform Infrastructure Constitution

## Core Principles

### I. Infrastructure as Code First
All infrastructure changes MUST be expressed as Terraform code before deployment. Manual changes to live infrastructure are prohibited except for emergency incident response, which MUST be documented and backported to code within 24 hours. Every resource, configuration, and secret reference MUST exist in version-controlled `.tf` files.

**Rationale**: Ensures reproducibility, auditability, and prevents configuration drift that leads to production incidents.

### II. Module Isolation
Each infrastructure module (cloudflare/, portainer/, proxmox/) MUST maintain independent state files and provider configurations. Modules MUST NOT share variables or resources directly. Cross-module dependencies MUST be handled via outputs and external data sources or explicit input variables.

**Rationale**: Enables safe parallel development, reduces blast radius of changes, and prevents cascading failures across unrelated infrastructure components.

### III. Security by Default
Sensitive values (API tokens, passwords, credentials) MUST be marked with `sensitive = true` in variable definitions. Production secrets MUST reside in `.tfvars` files that are git-ignored. Secrets MUST NEVER appear in plan output, state files committed to version control, or log messages.

**Rationale**: Prevents credential leaks, ensures compliance with security policies, and protects production systems from unauthorized access.

### IV. Documentation Currency
Every module MUST maintain current documentation in CLAUDE.md describing its purpose, managed resources, required variables, and example usage. Changes to infrastructure MUST update documentation in the same commit. Stale or missing documentation blocks feature approval.

**Rationale**: Enables team members and AI agents to understand and safely modify infrastructure without tribal knowledge or reverse engineering.

### V. State Management Discipline
Terraform state MUST be treated as the single source of truth for deployed infrastructure. State modifications outside `terraform apply` (manual edits, direct API calls) are prohibited. Before destructive changes, state MUST be backed up. Import existing resources rather than recreating them.

**Rationale**: Prevents state corruption, data loss, and service disruptions caused by state/reality desynchronization.

## Technology Standards

### Terraform Practices
- **Version Pinning**: Provider versions MUST be pinned in `providers.tf` using `required_providers` block
- **Variable Validation**: Complex variables (maps, objects) MUST include validation rules and descriptions
- **Output Clarity**: Outputs MUST have descriptions explaining their purpose and usage
- **Template Usage**: Docker Compose files MUST use `.tpl` extension and `templatefile()` function for variable substitution

### Module Structure
Each module MUST contain:
- `main.tf`: Primary resource definitions
- `variables.tf`: Input variable declarations with types and descriptions
- `providers.tf`: Provider configuration with version constraints
- `outputs.tf`: Module outputs (if any)
- `terraform.tfvars` (git-ignored): Actual secret values

### Prohibited Patterns
- Hardcoded credentials in `.tf` files
- Shared state files across modules
- Uncommitted changes to active infrastructure
- Destructive operations without plan review

## Change Management

### Planning Workflow
1. Run `terraform plan` and review all proposed changes
2. For destructive changes (deletions, replacements), document justification
3. Verify no sensitive data appears in plan output
4. Review plan with stakeholders if changes affect production services
5. Apply changes only after approval

### Testing Requirements
- **Validation**: Run `terraform validate` before commit
- **Formatting**: Run `terraform fmt` to ensure consistent code style
- **State Consistency**: Verify `terraform plan` shows no unexpected drift before new changes

### Review Gates
- Changes to production modules MUST be reviewed
- New modules MUST include documentation and example `.tfvars`
- Provider version upgrades MUST be tested in non-production first

## Governance

### Amendment Procedure
Constitution changes require:
1. Documented rationale for the change
2. Analysis of impact on existing modules and workflows
3. Update to version number per semantic versioning rules
4. Synchronization of dependent templates (plan, spec, tasks)
5. Commit message format: `docs: amend constitution to vX.Y.Z (summary)`

### Versioning Policy
- **MAJOR**: Principle removal, redefinition, or new mandatory constraint that breaks existing workflows
- **MINOR**: New principle added or expanded guidance that doesn't break existing practices
- **PATCH**: Clarifications, typo fixes, wording improvements, non-semantic refinements

### Compliance Review
- All infrastructure changes MUST verify alignment with Core Principles before apply
- Violations MUST be documented and justified or resolved before merge
- Constitution supersedes all other practices and conventions

### Agent Guidance
Runtime development guidance for AI agents (Claude Code, GitHub Copilot, etc.) is maintained in `/home/home/terraform/ai/CLAUDE.md`. This file provides project-specific context and MUST be updated when new modules or services are added.

**Version**: 1.0.0 | **Ratified**: 2025-10-02 | **Last Amended**: 2025-10-02
