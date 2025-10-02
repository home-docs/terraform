# Research: rwMarkable Deployment

**Feature**: rwMarkable Application Deployment
**Date**: 2025-10-02

## Research Questions & Findings

### 1. rwMarkable Docker Configuration

**Question**: What Docker image, ports, volumes, and environment variables are required for rwMarkable?

**Decision**: Use official ghcr.io/fccview/rwmarkable:latest image with standard configuration

**Rationale**:
- Official image maintained by project maintainer (fccview)
- Production-ready with Next.js application
- Supports both AMD64 and ARM64 platforms
- Well-documented deployment requirements

**Key Findings**:
- **Docker Image**: `ghcr.io/fccview/rwmarkable:latest`
- **Container Port**: 3000 (Next.js default)
- **Recommended Host Port**: 1122 (can be customized)
- **Required Volumes**:
  - Data directory: `/app/data` (read-write) - stores user data, notes, checklists
  - Config directory: `/app/config` (read-only) - stores configuration files
  - Cache directory: `/app/.next/cache` (read-write) - Next.js build cache (optional)
- **Environment Variables**:
  - `NODE_ENV=production` (required for production mode)
  - `HTTPS=true` (optional, for HTTPS enforcement)
- **Authentication**: Built-in user management via `/auth/setup` on first visit
- **Platform**: Default AMD64, ARM64 available

**Alternatives Considered**:
- Building custom Docker image: Rejected - unnecessary complexity, official image sufficient
- Using different base image: Rejected - official image is optimized and maintained

### 2. Existing Portainer Stack Patterns

**Question**: What patterns should rwMarkable follow from existing stacks?

**Decision**: Follow karakeep pattern (similar Next.js application) with single-service deployment

**Rationale**:
- karakeep is also a Next.js self-hosted application
- Established variable patterns (docker_config_path, docker_user_puid/pgid, docker_timezone)
- Standard restart policy and deployment configuration
- Proven pattern for external-facing services

**Key Findings**:
- **Restart Policy**: `unless-stopped` (matches all existing stacks)
- **Deployment Type**: `standalone` (standard for single-endpoint stacks)
- **Method**: `string` (Compose file passed as string via templatefile())
- **Volume Path Pattern**: `${docker_config_path}/<stack-name>/...`
- **Resource Limits**: Not explicitly set in existing stacks (system handles allocation)
- **Common Variables**:
  - `docker_config_path`: Base path for persistent data
  - `docker_user_puid`: User ID for file permissions
  - `docker_user_pgid`: Group ID for file permissions
  - `docker_timezone`: Container timezone

**Alternatives Considered**:
- Multi-service stack like karakeep: Not needed - rwMarkable is self-contained
- Custom variable names: Rejected - breaks consistency with existing stacks

### 3. DNS Record Configuration

**Question**: How should the rw.ketwork.in DNS record be configured?

**Decision**: Add to external records section with proxied=true, IP 15.235.186.122

**Rationale**:
- Clarified during /clarify: proxied through Cloudflare for CDN/DDoS protection
- Clarified during /clarify: use same IP as other external services (15.235.186.122)
- Matches existing pattern for internet-facing services

**Key Findings**:
- **Record Type**: A record (IPv4 address)
- **Subdomain**: "rw" (creates rw.ketwork.in)
- **IP Address**: 15.235.186.122 (same as homeassistant, immich, jellyfin, etc.)
- **Proxied**: true (routes through Cloudflare CDN)
- **TTL**: 1 (automatic, Cloudflare default for proxied records)
- **Location**: cloudflare/terraform.tfvars under "External Records" section

**Alternatives Considered**:
- Direct connection (proxied=false): Rejected - clarification specified Cloudflare proxy
- Internal IP (10.0.1.177): Rejected - requirement is external internet access
- Custom TTL: Not needed - automatic TTL (1) is standard for proxied records

### 4. Storage and Data Persistence

**Question**: Where should rwMarkable data be stored?

**Decision**: Use ${docker_config_path}/rwmarkable with subdirectories for data, config, cache

**Rationale**:
- Clarified during /clarify: follow docker_config_path pattern
- Matches existing stack storage structure
- Separates concerns (data, config, cache) for maintainability
- Ensures persistence across container restarts per NFR-002, NFR-004

**Key Findings**:
- **Base Path**: `${docker_config_path}/rwmarkable`
- **Data Subdirectory**: `${docker_config_path}/rwmarkable/data` → `/app/data` (user content, credentials)
- **Config Subdirectory**: `${docker_config_path}/rwmarkable/config` → `/app/config` (application config)
- **Cache Subdirectory**: `${docker_config_path}/rwmarkable/cache` → `/app/.next/cache` (Next.js cache, optional)
- **Permissions**: Container needs read-write on data and cache, read-only on config

**Alternatives Considered**:
- Flat structure (no subdirectories): Rejected - less organized, harder to backup selectively
- Different base path: Rejected - breaks convention with existing stacks

### 5. Port Mapping Strategy

**Question**: What host port should expose rwMarkable?

**Decision**: Use port 5230 (following existing port allocation pattern)

**Rationale**:
- Existing stacks use 5xxx range (karakeep:5125, open_webui:5225)
- Port 1122 (recommended by rwMarkable docs) conflicts with potential SSH alternatives
- Port 5230 is available, above 3000, not system-reserved, and follows project convention

**Key Findings**:
- **Container Port**: 3000 (rwMarkable internal)
- **Host Port**: 5230 (exposed on Docker host)
- **Access Method**: External access via Cloudflare proxy to rw.ketwork.in, not direct port access
- **Reverse Proxy**: Likely handled by existing infrastructure (not in Portainer config)

**Alternatives Considered**:
- Port 1122 (docs recommendation): Rejected - may conflict with SSH alternatives
- Port 5130: Rejected - too close to existing ports, choosing higher number for spacing
- Direct 3000:3000 mapping: Rejected - may conflict with other services, breaks port range convention

### 6. Variable Requirements

**Question**: Does rwMarkable need new Terraform variables?

**Decision**: No new variables required in portainer/variables.tf

**Rationale**:
- Uses existing standard variables (docker_config_path, docker_user_puid, docker_user_pgid, docker_timezone)
- Built-in authentication (no OIDC secrets needed per clarification change)
- No external service dependencies requiring credentials
- Environment variables are static (NODE_ENV=production)

**Key Findings**:
- **Existing Variables Used**:
  - docker_config_path: For persistent storage
  - docker_user_puid: For file ownership
  - docker_user_pgid: For file ownership
  - docker_timezone: For container timezone
  - portainer_endpoint_id: For stack deployment target
- **No New Variables Needed**: All configuration is static or uses existing variables

**Alternatives Considered**:
- Add rwmarkable_port variable: Not needed - static port 5230
- Add rwmarkable_image_tag variable: Not needed - use :latest, update via stack edit if needed

## Summary

**Infrastructure Changes Required**:
1. **Portainer Module**:
   - New file: `portainer/compose-files/rwmarkable.yml.tpl`
   - Modified: `portainer/main.tf` (add portainer_stack.rwmarkable resource)
   - Modified: `portainer/terraform.tfvars` (no new variables, just stack activation)

2. **Cloudflare Module**:
   - Modified: `cloudflare/terraform.tfvars` (add "rw" to external records)

3. **Documentation**:
   - Modified: `ai/CLAUDE.md` (add rwmarkable to active stacks)

**Deployment Characteristics**:
- Single container deployment
- Port 5230 (host) → 3000 (container)
- Persistent storage: ${docker_config_path}/rwmarkable/{data,config,cache}
- External access: rw.ketwork.in → 15.235.186.122 (proxied)
- Built-in authentication (no external SSO)
- Restart policy: unless-stopped

**Testing Approach**:
- terraform validate on both modules
- terraform plan review before apply
- DNS resolution check (dig rw.ketwork.in)
- Web access test (browse to rw.ketwork.in)
- Data persistence test (create note, restart, verify)
- Authentication test (user registration/login)
