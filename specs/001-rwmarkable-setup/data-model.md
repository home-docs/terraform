# Data Model: rwMarkable Deployment

**Feature**: rwMarkable Application Deployment
**Date**: 2025-10-02

## Overview

This feature involves Infrastructure as Code resources rather than application data models. The "entities" are Terraform resources and their configurations.

## Terraform Resource Entities

### 1. Portainer Stack Resource

**Resource Type**: `portainer_stack`
**Resource Name**: `rwmarkable`
**Full Identifier**: `portainer_stack.rwmarkable`

**Attributes**:
- `name` (string, required): "rwmarkable"
- `deployment_type` (string, required): "standalone"
- `method` (string, required): "string"
- `endpoint_id` (number, required): `var.portainer_endpoint_id`
- `stack_file_content` (string, required): Docker Compose YAML from templatefile()

**Relationships**:
- Depends on: Portainer endpoint (via endpoint_id variable)
- References: Docker Compose template file (rwmarkable.yml.tpl)
- Uses variables: docker_config_path, docker_user_puid, docker_user_pgid, docker_timezone

**State Transitions**:
- CREATE: Stack deployed to Portainer
- UPDATE: Stack configuration changed, redeployment triggered
- DELETE: Stack removed from Portainer

**Validation Rules**:
- name must be unique within endpoint
- deployment_type must be "standalone", "swarm", or "kubernetes"
- endpoint_id must reference existing Portainer endpoint

### 2. DNS A Record Entry

**Resource Type**: Map entry in `var.a_records`
**Map Key**: "rw"
**Accessed via**: `cloudflare_dns_record.a_records["rw"]`

**Attributes**:
- `content` (string, required): "15.235.186.122"
- `proxied` (bool, optional): true
- `ttl` (number, optional): 1 (automatic when proxied)

**Derived Attributes** (from cloudflare_dns_record resource):
- `name`: "rw" (from map key)
- `type`: "A" (hardcoded in resource)
- `zone_id`: var.cloudflare_zone_id

**Relationships**:
- Belongs to: Cloudflare zone (via zone_id)
- Points to: Server at IP 15.235.186.122
- Creates: rw.ketwork.in FQDN

**State Transitions**:
- CREATE: DNS record added to Cloudflare zone
- UPDATE: IP address or proxy setting changed
- DELETE: DNS record removed from zone

**Validation Rules**:
- content must be valid IPv4 address
- proxied cannot be true if TTL is set to non-automatic value
- ttl must be 1 (automatic) or 60-86400 when not proxied

### 3. Docker Compose Configuration

**File**: `portainer/compose-files/rwmarkable.yml.tpl`
**Type**: Template file (HCL templatefile() function)

**Service Definition**:
```yaml
services:
  rwmarkable:
    image: ghcr.io/fccview/rwmarkable:latest
    container_name: rwmarkable
    restart: unless-stopped
    ports:
      - 5230:3000
    volumes:
      - ${docker_config_path}/rwmarkable/data:/app/data
      - ${docker_config_path}/rwmarkable/config:/app/config:ro
      - ${docker_config_path}/rwmarkable/cache:/app/.next/cache
    environment:
      - NODE_ENV=production
      - PUID=${docker_user_puid}
      - PGID=${docker_user_pgid}
      - TZ=${docker_timezone}
```

**Template Variables**:
- `docker_config_path`: Base path for persistent volumes
- `docker_user_puid`: User ID for file permissions
- `docker_user_pgid`: Group ID for file permissions
- `docker_timezone`: Container timezone

**Volume Mounts**:
1. Data volume (read-write):
   - Host: `${docker_config_path}/rwmarkable/data`
   - Container: `/app/data`
   - Purpose: User data, notes, checklists, credentials
   - Persistence: Required (NFR-002, NFR-004)

2. Config volume (read-only):
   - Host: `${docker_config_path}/rwmarkable/config`
   - Container: `/app/config`
   - Purpose: Application configuration files
   - Persistence: Optional (can be empty initially)

3. Cache volume (read-write):
   - Host: `${docker_config_path}/rwmarkable/cache`
   - Container: `/app/.next/cache`
   - Purpose: Next.js build cache
   - Persistence: Optional (performance optimization)

**Environment Variables**:
- `NODE_ENV`: Always "production" for deployed instance
- `PUID`: File ownership user ID (from docker_user_puid)
- `PGID`: File ownership group ID (from docker_user_pgid)
- `TZ`: Timezone (from docker_timezone)

**Port Mapping**:
- Host port: 5230 (external access via reverse proxy)
- Container port: 3000 (Next.js default)

**Restart Policy**: `unless-stopped` (per NFR-001)

## Terraform Variables

### Existing Variables (No Changes Required)

All required variables already exist in `portainer/variables.tf`:

1. **portainer_endpoint_id**
   - Type: number
   - Purpose: Target Portainer endpoint for stack deployment

2. **docker_config_path**
   - Type: string
   - Purpose: Base path for persistent storage volumes

3. **docker_user_puid**
   - Type: string
   - Purpose: User ID for container file permissions

4. **docker_user_pgid**
   - Type: string
   - Purpose: Group ID for container file permissions

5. **docker_timezone**
   - Type: string
   - Purpose: Timezone for container

### No New Variables Required

Per research findings, rwMarkable uses only standard configuration:
- Port is static (5130)
- Image is static (ghcr.io/fccview/rwmarkable:latest)
- Built-in authentication (no SSO secrets needed)
- Environment variables are static (NODE_ENV=production)

## State Dependencies

### Terraform State Dependencies

1. **Portainer Module State**:
   - New resource: `portainer_stack.rwmarkable`
   - State file: `portainer/terraform.tfstate` (or remote backend)
   - Dependencies: Portainer provider, endpoint configuration

2. **Cloudflare Module State**:
   - Modified resource: `cloudflare_dns_record.a_records["rw"]`
   - State file: `cloudflare/terraform.tfstate` (or remote backend)
   - Dependencies: Cloudflare provider, zone configuration

### Cross-Module Dependencies

**None** (per Constitution II. Module Isolation):
- Portainer and Cloudflare modules remain independent
- No shared state files
- No direct resource references between modules
- Integration happens at runtime (DNS points to server running containers)

## Data Lifecycle

### Initial Deployment
1. Terraform creates Portainer stack resource
2. Terraform creates Cloudflare DNS record
3. Portainer deploys rwmarkable container
4. Container creates initial directory structure in volumes
5. First access to rw.ketwork.in triggers `/auth/setup`
6. Admin user created during initial setup

### Ongoing Operation
1. Container writes user data to `/app/data` (persistent volume)
2. Container reads configuration from `/app/config` (if present)
3. Container caches Next.js builds in `/app/.next/cache`
4. DNS queries for rw.ketwork.in return 15.235.186.122 (proxied via Cloudflare)

### Container Restart
1. Container stops
2. Volume data remains on host filesystem
3. Container recreates using same volumes
4. User data, credentials, preferences restored (per NFR-002, NFR-004)

### Stack Update
1. Terraform modifies stack resource
2. Portainer redeploys container with new configuration
3. Volumes remain attached
4. Data persists across update

### Decommissioning
1. Terraform destroy removes stack resource
2. Portainer removes container
3. Volumes remain on host (manual cleanup required)
4. DNS record removed by Terraform

## Validation Constraints

### Terraform Validation
- HCL syntax must be valid
- Resource types must match provider schema
- Variable types must match declarations
- Template file must exist at specified path

### Runtime Validation
- Docker host must have port 5230 available
- Storage paths must be writable by PUID/PGID
- Cloudflare zone must be accessible
- Server must be reachable at 15.235.186.122

### Acceptance Criteria Validation
- DNS record resolves to correct IP (FR-002)
- Web interface loads at rw.ketwork.in (FR-001, FR-005)
- Data persists across restarts (FR-004, NFR-002)
- Stack manageable via Portainer (FR-003)
- Authentication functional (FR-008)
