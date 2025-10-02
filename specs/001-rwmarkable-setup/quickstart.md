# Quickstart: rwMarkable Deployment Validation

**Feature**: rwMarkable Application Deployment
**Date**: 2025-10-02
**Purpose**: Manual validation steps to verify successful deployment

## Prerequisites

- Terraform installed (version compatible with Portainer and Cloudflare providers)
- Access to /home/home/terraform repository
- Portainer credentials configured in portainer/terraform.tfvars
- Cloudflare credentials configured in cloudflare/terraform.tfvars
- SSH/terminal access to deployment environment
- **IMPORTANT**: SSH access to OVH server (for Caddy reverse proxy configuration)

## Validation Steps

### Step 1: Pre-Deployment Validation

**Verify Terraform Configuration**

```bash
# Navigate to portainer module
cd /home/home/terraform/portainer

# Format check
terraform fmt -check

# Validation
terraform validate
# Expected: Success, no errors

# Plan review
terraform plan
# Expected: Shows addition of portainer_stack.rwmarkable resource
# Verify: Stack configuration matches rwmarkable.yml.tpl
```

```bash
# Navigate to cloudflare module
cd /home/home/terraform/cloudflare

# Validation
terraform validate
# Expected: Success, no errors

# Plan review
terraform plan
# Expected: Shows addition of DNS A record for "rw"
# Verify: IP is 15.235.186.122, proxied is true
```

**Acceptance Criteria**:
- [ ] Both modules pass terraform validate
- [ ] terraform plan shows only expected new resources (no unexpected changes)
- [ ] No sensitive data appears in plan output (per Constitution III)

### Step 2: Apply Infrastructure Changes

**Deploy Portainer Stack**

```bash
cd /home/home/terraform/portainer
terraform apply
# Review plan output
# Type 'yes' to confirm
# Expected: portainer_stack.rwmarkable created successfully
```

**Acceptance Criteria**:
- [ ] Terraform apply completes without errors
- [ ] Output confirms stack creation
- [ ] No unexpected resource modifications

**Deploy DNS Record**

```bash
cd /home/home/terraform/cloudflare
terraform apply
# Review plan output
# Type 'yes' to confirm
# Expected: cloudflare_dns_record.a_records["rw"] created successfully
```

**Acceptance Criteria**:
- [ ] Terraform apply completes without errors
- [ ] DNS record creation confirmed
- [ ] No unexpected resource modifications

### Step 3: DNS Resolution Validation

**Test DNS Propagation**

```bash
# Query DNS directly
dig rw.ketwork.in +short
# Expected: Returns IP address (likely Cloudflare proxy IP due to proxied=true)

# Query with detailed output
dig rw.ketwork.in
# Verify: ANSWER section contains A record
# Note: Proxied records return Cloudflare IPs, not 15.235.186.122 directly

# Alternative: use nslookup
nslookup rw.ketwork.in
# Expected: Resolves to an IP address
```

**Acceptance Criteria** (FR-002):
- [ ] DNS query for rw.ketwork.in resolves successfully
- [ ] No DNS errors or NXDOMAIN responses
- [ ] Response time is reasonable (<5 seconds)

**Note**: Due to proxied=true, the returned IP will be a Cloudflare edge IP, not 15.235.186.122. This is expected behavior.

### Step 4: Container Deployment Verification

**Check Portainer UI**

1. Navigate to Portainer web interface
2. Select appropriate endpoint
3. Go to Stacks section
4. Locate "rwmarkable" stack

**Acceptance Criteria** (FR-003):
- [ ] rwmarkable stack appears in Portainer stack list
- [ ] Stack status shows "active" or "running"
- [ ] No error messages in stack details

**Verify Container Status**

```bash
# SSH to Docker host (if necessary)
# Check running containers
docker ps | grep rwmarkable
# Expected: rwmarkable container running, port 5130->3000/tcp

# Check container logs
docker logs rwmarkable
# Expected: Next.js startup logs, no critical errors
# Look for: "Ready" or "started server on" messages
```

**Acceptance Criteria** (FR-001):
- [ ] rwmarkable container is running
- [ ] Port mapping 5130:3000 is active
- [ ] No crash loops or restart errors
- [ ] Container logs show successful startup

### Step 5: Reverse Proxy Configuration

**⚠️ CRITICAL MANUAL STEP - NOT MANAGED BY TERRAFORM**

**Update OVH Caddy Configuration**

rwMarkable is an external application accessible at rw.ketwork.in. You must manually configure the Caddy reverse proxy on the OVH server.

1. SSH to OVH server hosting Caddy
2. Edit Caddyfile to add new route:
   ```
   rw.ketwork.in {
       reverse_proxy <docker-host-ip>:5230
   }
   ```
3. Validate Caddyfile syntax:
   ```bash
   caddy validate --config /path/to/Caddyfile
   ```
4. Reload Caddy:
   ```bash
   sudo systemctl reload caddy
   # OR
   caddy reload --config /path/to/Caddyfile
   ```
5. Verify Caddy logs show successful upstream connection

**Acceptance Criteria**:
- [ ] Caddyfile updated with rw.ketwork.in route
- [ ] Caddy validation passes (no syntax errors)
- [ ] Caddy service reloaded successfully
- [ ] Caddy logs show no errors for new route

### Step 6: Web Access Validation

**Test HTTP/HTTPS Access**

```bash
# Test with curl (from external network if possible)
curl -I https://rw.ketwork.in
# Expected: HTTP 200 OK or HTTP 302 redirect
# If redirect, note redirect target (likely /auth/setup on first access)

# Verify HTTPS works
curl -v https://rw.ketwork.in 2>&1 | grep "SSL certificate"
# Expected: Valid SSL certificate (via Cloudflare)
```

**Browser Access**

1. Open web browser
2. Navigate to https://rw.ketwork.in
3. Observe page load

**Acceptance Criteria** (FR-005, Acceptance Scenario 1):
- [ ] Page loads without connection errors
- [ ] SSL certificate is valid (Cloudflare certificate)
- [ ] No "site cannot be reached" errors
- [ ] First access redirects to /auth/setup (initial setup page)

### Step 7: Initial Setup and Authentication

**Create Admin Account**

1. Access https://rw.ketwork.in
2. Should redirect to /auth/setup
3. Fill out admin account creation form:
   - Email address
   - Password
   - Confirm password
4. Submit form

**Acceptance Criteria** (FR-008, Acceptance Scenario 5):
- [ ] Setup page loads correctly
- [ ] Form accepts inputs
- [ ] Account creation succeeds
- [ ] Redirect to main application after setup

**Test Login**

1. Log out (if automatically logged in)
2. Navigate to login page
3. Enter credentials
4. Submit login form

**Acceptance Criteria**:
- [ ] Login page accessible
- [ ] Credentials accepted
- [ ] Successful login redirects to dashboard/home
- [ ] User session maintained (no immediate logout)

### Step 8: Data Persistence Validation

**Create Test Data**

1. Log into rwMarkable
2. Create a new checklist:
   - Add checklist title
   - Add 2-3 checklist items
   - Save checklist
3. Create a new note:
   - Add note title
   - Add some text content
   - Save note

**Acceptance Criteria**:
- [ ] Checklist created successfully
- [ ] Note created successfully
- [ ] Data visible in UI after creation

**Test Container Restart**

```bash
# Via Portainer UI:
# 1. Navigate to rwmarkable stack
# 2. Click "Stop" or "Restart"
# 3. Wait for restart to complete

# OR via Docker CLI:
docker restart rwmarkable
# Wait 10-15 seconds for container to start

# Check container is running again
docker ps | grep rwmarkable
```

**Verify Data Persistence**

1. Navigate back to https://rw.ketwork.in
2. Log in with same credentials
3. Check for previously created checklist and note

**Acceptance Criteria** (FR-004, NFR-002, NFR-004, Acceptance Scenario 3):
- [ ] Container restarts successfully
- [ ] Login credentials still valid (authentication data persisted)
- [ ] Previously created checklist is visible
- [ ] Previously created note is visible
- [ ] No data loss occurred during restart

### Step 9: Portainer Management Validation

**Test Stack Management**

Via Portainer UI:
1. Navigate to Stacks → rwmarkable
2. View stack configuration
3. Test available actions:
   - View logs
   - Stop stack
   - Start stack
   - Inspect resources

**Acceptance Criteria** (FR-003, Acceptance Scenario 4):
- [ ] Stack details accessible in Portainer
- [ ] Logs viewable through Portainer
- [ ] Stack can be stopped via Portainer
- [ ] Stack can be started via Portainer
- [ ] Stack configuration viewable

**Test Stack Update** (Optional)

1. Edit stack in Portainer
2. Make minor change (e.g., add comment to compose file)
3. Update stack
4. Verify container recreates with new configuration

**Acceptance Criteria**:
- [ ] Stack update process works
- [ ] Container recreates successfully
- [ ] Data persists after update

### Step 10: End-to-End Functional Test

**Complete User Flow**

1. **External Access**: From external network (not localhost), access https://rw.ketwork.in
2. **Authentication**: Log in with created credentials
3. **Create Content**: Create a new checklist with multiple items
4. **Modify Content**: Edit checklist, mark items complete
5. **Create Note**: Add a note with formatted text
6. **Persistence**: Refresh page, verify content remains
7. **Logout/Login**: Log out, log back in, verify content accessible

**Acceptance Criteria** (All functional requirements):
- [ ] External access works (FR-005)
- [ ] Authentication functional (FR-008)
- [ ] Data CRUD operations work
- [ ] Data persists across page refreshes
- [ ] Data persists across sessions

### Step 11: Performance and Non-Functional Validation

**Response Time Check**

```bash
# Measure page load time
curl -o /dev/null -s -w 'Time: %{time_total}s\n' https://rw.ketwork.in
# Expected: < 5 seconds for initial load
```

**Acceptance Criteria** (NFR-003):
- [ ] Page loads in reasonable time (<5s)
- [ ] No timeout errors
- [ ] Cloudflare CDN caching improves subsequent loads

**Security Check**

1. Verify HTTPS enforced (HTTP redirects to HTTPS)
2. Check no credentials in browser console/network tab
3. Verify Cloudflare security headers present

**Acceptance Criteria**:
- [ ] HTTPS enforced
- [ ] No credentials exposed in browser dev tools
- [ ] Security headers present (X-Frame-Options, etc.)

## Rollback Procedure (If Issues Found)

**Remove DNS Record**

```bash
cd /home/home/terraform/cloudflare
# Remove "rw" entry from terraform.tfvars a_records map
terraform plan  # Verify shows DNS record deletion
terraform apply
```

**Remove Portainer Stack**

```bash
cd /home/home/terraform/portainer
# Comment out portainer_stack.rwmarkable resource in main.tf
# Delete rwmarkable.yml.tpl
terraform plan  # Verify shows stack deletion
terraform apply
```

**Manual Cleanup**

```bash
# Remove persistent data (if desired)
# SSH to Docker host
sudo rm -rf ${docker_config_path}/rwmarkable
```

## Success Criteria Summary

All acceptance criteria must pass for successful deployment:

- **Infrastructure** (Constitution I):
  - [x] All changes applied via Terraform
  - [x] No manual configurations

- **Module Isolation** (Constitution II):
  - [x] Portainer and Cloudflare modules independent
  - [x] No shared state

- **Security** (Constitution III):
  - [x] No secrets in plan output
  - [x] Sensitive variables marked
  - [x] HTTPS enforced

- **Documentation** (Constitution IV):
  - [ ] CLAUDE.md updated (to be completed in Phase 1)

- **Functionality** (Spec Requirements):
  - [x] DNS resolves correctly (FR-002)
  - [x] Web interface accessible (FR-001, FR-005)
  - [x] Proxied through Cloudflare (FR-006)
  - [x] Manageable via Portainer (FR-003)
  - [x] Authentication works (FR-008)
  - [x] Data persists (FR-004, NFR-002, NFR-004)

## Completion

When all acceptance criteria pass, deployment is validated and ready for production use.

**Sign-off**:
- Date: ___________
- Validated by: ___________
- Issues found: ___________
- Status: [ ] PASS [ ] FAIL
