# Deployment Reminders

This file contains important manual steps that must be completed after infrastructure changes.

## Reverse Proxy Configuration

### External Applications (Internet-Facing)

**Action Required**: Update OVH Caddy configuration

When deploying new external applications (those with proxied DNS records), remember to:
1. SSH to OVH server hosting Caddy reverse proxy
2. Update Caddyfile with new application route
3. Configure upstream to point to application's host:port
4. Reload/restart Caddy service
5. Verify HTTPS certificate provisioning

**Recent External Applications**:
- rw.ketwork.in → rwmarkable (port 5230) - **✅ COMPLETED** (2025-10-02)

### Internal Applications (LAN-Only)

**Action Required**: Update Heimdall Caddy configuration

When deploying new internal applications (those with internal DNS records), remember to:
1. SSH to Heimdall server hosting Caddy reverse proxy
2. Update Caddyfile with new application route
3. Configure upstream to point to application's host:port
4. Reload/restart Caddy service

**Recent Internal Applications**:
- (None pending)

---

## Verification Checklist

After updating Caddy configurations:
- [ ] DNS resolves correctly (`dig <domain>`)
- [ ] HTTPS works (valid certificate)
- [ ] Application accessible via domain
- [ ] No certificate errors in browser
- [ ] Caddy logs show successful upstream connection

## Notes

- External applications require DNS records in cloudflare/terraform.tfvars
- Caddy configurations are NOT managed by Terraform (manual updates required)
- Always test Caddyfile syntax before reloading: `caddy validate`
- Keep this file updated when deploying new applications
