# Tasks: rwMarkable Application Deployment

**Input**: Design documents from `/home/home/terraform/specs/001-rwmarkable-setup/`
**Prerequisites**: plan.md, research.md, data-model.md, quickstart.md

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: tech stack, libraries, structure
2. Load optional design documents:
   → data-model.md: Extract entities → Terraform resources
   → research.md: Extract decisions → configuration tasks
3. Generate tasks by category:
   → Setup: Docker Compose template creation
   → Infrastructure: Terraform resource definitions
   → Configuration: DNS and variable configuration
   → Validation: Terraform validate, plan, apply
   → Manual Steps: Reverse proxy configuration
   → Testing: Acceptance testing per quickstart.md
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Same file = sequential (no [P])
   → Infrastructure before validation
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All resources have creation tasks?
   → All modules validated?
   → Manual steps documented?
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- **Portainer module**: `/home/home/terraform/portainer/`
- **Cloudflare module**: `/home/home/terraform/cloudflare/`
- **Documentation**: `/home/home/terraform/ai/`

## Phase 3.1: Setup

- [x] T001 Create Docker Compose template file at /home/home/terraform/portainer/compose-files/rwmarkable.yml.tpl with rwMarkable service configuration (image: ghcr.io/fccview/rwmarkable:latest, port 5230:3000, volumes for data/config/cache, environment variables)

## Phase 3.2: Infrastructure Configuration

**Portainer Module Changes**:
- [x] T002 Add portainer_stack.rwmarkable resource to /home/home/terraform/portainer/main.tf (name: "rwmarkable", deployment_type: "standalone", method: "string", endpoint_id: var.portainer_endpoint_id, stack_file_content: templatefile for rwmarkable.yml.tpl)

**Cloudflare Module Changes**:
- [x] T003 [P] Add "rw" DNS A record entry to /home/home/terraform/cloudflare/terraform.tfvars in a_records map (content: "15.235.186.122", proxied: true, ttl: 1)

## Phase 3.3: Validation (Portainer Module)

- [x] T004 Run terraform fmt in /home/home/terraform/portainer directory to format code
- [x] T005 Run terraform validate in /home/home/terraform/portainer directory to check syntax and configuration
- [x] T006 Run terraform plan in /home/home/terraform/portainer directory to preview rwmarkable stack addition

## Phase 3.4: Validation (Cloudflare Module)

- [x] T007 [P] Run terraform fmt in /home/home/terraform/cloudflare directory to format code
- [x] T008 [P] Run terraform validate in /home/home/terraform/cloudflare directory to check syntax
- [x] T009 [P] Run terraform plan in /home/home/terraform/cloudflare directory to preview DNS record addition

## Phase 3.5: Apply Infrastructure Changes

**CRITICAL**: Review plan output before executing apply commands

- [x] T010 Run terraform apply in /home/home/terraform/portainer directory to create rwmarkable stack (review plan output, confirm before applying)
- [x] T011 Run terraform apply in /home/home/terraform/cloudflare directory to create rw DNS record (review plan output, confirm before applying)

## Phase 3.6: Manual Configuration (NOT Terraform Managed)

**⚠️ CRITICAL MANUAL STEP**:
- [x] T012 SSH to OVH server and update Caddy reverse proxy configuration: Add rw.ketwork.in route pointing to Docker host IP port 5230, validate Caddyfile syntax with `caddy validate`, reload Caddy service with `sudo systemctl reload caddy` or `caddy reload`

## Phase 3.7: Verification & Testing

**Container Verification**:
- [x] T013 Verify rwmarkable container is running via Portainer UI (navigate to Stacks, locate rwmarkable stack, confirm status is active/running)
- [x] T014 Check rwmarkable container logs via Docker CLI: `docker logs rwmarkable` (verify Next.js startup logs, look for "Ready" or "started server" messages, confirm no critical errors)

**DNS Verification**:
- [x] T015 [P] Test DNS resolution with `dig rw.ketwork.in` (verify A record resolves, note: proxied records return Cloudflare IPs not 15.235.186.122 directly)

**Web Access Verification**:
- [x] T016 Test HTTPS access with `curl -I https://rw.ketwork.in` (verify HTTP 200 OK or 302 redirect, confirm valid SSL certificate)
- [x] T017 Access https://rw.ketwork.in in browser and complete initial setup (create admin account via /auth/setup, verify successful login)

**Data Persistence Testing**:
- [x] T018 Create test data in rwMarkable (create checklist with 2-3 items, create note with text content, save both)
- [x] T019 Restart rwmarkable container via Portainer or Docker CLI: `docker restart rwmarkable` (wait 10-15 seconds for restart)
- [x] T020 Verify data persistence after restart (log back into rwMarkable, confirm checklist and note are still present, verify no data loss)

**Portainer Management Testing**:
- [x] T021 Test Portainer stack management capabilities (view stack details, check logs, test stop/start actions, verify stack configuration is viewable)

## Phase 3.8: End-to-End Validation

- [x] T022 Execute complete user flow from external network (access rw.ketwork.in, authenticate, create/edit checklist, create note, refresh page to verify persistence, logout and login to verify session)
- [x] T023 Measure page load performance with `curl -o /dev/null -s -w 'Time: %{time_total}s\n' https://rw.ketwork.in` (verify load time <5 seconds)
- [x] T024 Verify security configuration (HTTPS enforced, no credentials in browser console/network tab, Cloudflare security headers present)

## Phase 3.9: Documentation Update

- [x] T025 [P] Verify /home/home/terraform/ai/CLAUDE.md has been updated with rwmarkable stack information (already completed in Phase 1, confirm presence)
- [x] T026 [P] Update /home/home/terraform/ai/.specify/memory/deployment-reminders.md to mark rwmarkable Caddy configuration as completed (change PENDING to COMPLETED)

## Dependencies

**Critical Path**:
1. T001 (Docker Compose template) MUST complete before T002 (stack resource)
2. T002 (stack resource) MUST complete before T004-T006 (Portainer validation)
3. T003 (DNS record) MUST complete before T007-T009 (Cloudflare validation)
4. T006 and T009 MUST complete before T010-T011 (applies)
5. T010-T011 MUST complete before T012 (Caddy config)
6. T012 MUST complete before T013-T024 (testing)
7. T013-T024 MUST complete before T025-T026 (documentation)

**Parallel Opportunities**:
- T003 can run in parallel with T001-T002 (different modules)
- T007-T009 can run in parallel with T004-T006 (different modules)
- T015 can run in parallel with T013-T014 (independent verification)
- T025-T026 can run in parallel (different files)

**Blocking Dependencies**:
- T002 blocks T004-T006 (must have resource to validate)
- T010-T011 block T012-T024 (infrastructure must exist before configuration/testing)
- T012 blocks T016-T024 (reverse proxy required for web access)

## Parallel Execution Examples

### Example 1: Validation Phase
```bash
# Run Portainer and Cloudflare validation in parallel
# Terminal 1:
cd /home/home/terraform/portainer
terraform fmt && terraform validate && terraform plan

# Terminal 2 (simultaneously):
cd /home/home/terraform/cloudflare
terraform fmt && terraform validate && terraform plan
```

### Example 2: Independent Verification Tasks
```bash
# After infrastructure is deployed, run these verifications in parallel
# Terminal 1:
dig rw.ketwork.in

# Terminal 2 (simultaneously):
docker logs rwmarkable

# Terminal 3 (simultaneously):
# Open Portainer UI in browser to check stack status
```

## Notes

- **[P] tasks** = different files, no dependencies, safe for parallel execution
- **Always review** terraform plan output before applying changes
- **Caddy configuration** (T012) is NOT managed by Terraform - manual SSH required
- **Test data** created in T018 should be simple but sufficient to verify persistence
- **External access testing** (T022) should ideally be from a different network to verify Cloudflare proxy
- Commit infrastructure changes after successful validation (T024 completion)

## Task Execution Tips

1. **Pre-execution checks**:
   - Ensure you're on branch `001-rwmarkable-setup`
   - Verify terraform.tfvars files exist in both modules
   - Confirm SSH access to OVH server before starting

2. **During execution**:
   - Read each task description carefully
   - Use exact file paths provided
   - Don't skip validation steps (T004-T009)
   - Take notes during manual steps (T012)

3. **Error handling**:
   - If T005 or T008 fails: Fix syntax errors before proceeding
   - If T006 or T009 shows unexpected changes: Review and understand before apply
   - If T012 Caddy reload fails: Check Caddyfile syntax, review logs
   - If T020 data persistence fails: Check volume mounts and permissions

4. **Rollback procedure**:
   - If critical failure occurs, see quickstart.md "Rollback Procedure"
   - Comment out resources in .tf files
   - Run terraform apply to remove
   - Manual cleanup of persistent data if needed

## Validation Checklist

*GATE: Checked by execution before marking complete*

- [ ] All Terraform resources created successfully (T002, T003)
- [ ] All validation steps passed (T004-T009)
- [ ] Infrastructure applied without errors (T010-T011)
- [ ] Manual Caddy configuration completed (T012)
- [ ] Container running and accessible (T013-T017)
- [ ] Data persists across restarts (T018-T020)
- [ ] Portainer management functional (T021)
- [ ] End-to-end user flow works (T022-T024)
- [ ] Documentation updated (T025-T026)

## Estimated Completion Time

- **Phase 3.1-3.2** (Setup & Infrastructure): 20-30 minutes
- **Phase 3.3-3.4** (Validation): 10-15 minutes
- **Phase 3.5** (Apply): 5-10 minutes
- **Phase 3.6** (Manual Caddy Config): 10-15 minutes
- **Phase 3.7** (Verification & Testing): 20-30 minutes
- **Phase 3.8** (End-to-End Validation): 15-20 minutes
- **Phase 3.9** (Documentation): 5 minutes

**Total**: Approximately 1.5-2 hours for complete implementation and validation

## Success Criteria

All tasks (T001-T026) must be completed successfully:
- ✅ Docker Compose template created
- ✅ Terraform resources defined and applied
- ✅ DNS record created and resolving
- ✅ Caddy reverse proxy configured
- ✅ Container running and accessible
- ✅ Data persistence verified
- ✅ End-to-end functionality confirmed
- ✅ Documentation updated

**Sign-off**:
- Implementation complete: [ ]
- All tests passing: [ ]
- Ready for production use: [ ]
- Date: ___________
