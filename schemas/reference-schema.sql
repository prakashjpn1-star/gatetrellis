-- Canonical coordination design. Per-process response caches are rebuildable.
PRAGMA foreign_keys=ON;
CREATE TABLE policy_versions(id TEXT PRIMARY KEY, schema_version INTEGER NOT NULL CHECK(schema_version>0), canonical_json TEXT NOT NULL CHECK(json_valid(canonical_json)), digest TEXT NOT NULL UNIQUE, published_at INTEGER NOT NULL);
CREATE TABLE active_policy(id INTEGER PRIMARY KEY CHECK(id=1), version_id TEXT NOT NULL REFERENCES policy_versions(id), revision INTEGER NOT NULL CHECK(revision>0));
CREATE TABLE upstreams(id TEXT PRIMARY KEY, host TEXT NOT NULL CHECK(host IN('127.0.0.1','::1')), port INTEGER NOT NULL CHECK(port BETWEEN 1024 AND 65535), max_in_flight INTEGER NOT NULL CHECK(max_in_flight>0), draining INTEGER NOT NULL CHECK(draining IN(0,1)), revision INTEGER NOT NULL CHECK(revision>0));
CREATE TABLE token_buckets(scope_key TEXT PRIMARY KEY, units INTEGER NOT NULL CHECK(units>=0), burst_units INTEGER NOT NULL CHECK(burst_units>0), refill_units_per_second INTEGER NOT NULL CHECK(refill_units_per_second>0), last_refill_ms INTEGER NOT NULL, remainder INTEGER NOT NULL CHECK(remainder>=0), migration_version TEXT NOT NULL, CHECK(units<=burst_units));
CREATE TABLE permits(id TEXT PRIMARY KEY, request_id TEXT NOT NULL, attempt_no INTEGER NOT NULL CHECK(attempt_no>0), owner_instance TEXT NOT NULL, generation INTEGER NOT NULL CHECK(generation>0), policy_id TEXT NOT NULL REFERENCES policy_versions(id), route_id TEXT NOT NULL, upstream_id TEXT NOT NULL REFERENCES upstreams(id), deadline INTEGER NOT NULL, state TEXT NOT NULL CHECK(state IN('ACTIVE','RELEASED','EXPIRED')), UNIQUE(request_id,attempt_no));
CREATE TABLE circuit_state(upstream_id TEXT PRIMARY KEY REFERENCES upstreams(id), phase TEXT NOT NULL CHECK(phase IN('CLOSED','OPEN','HALF_OPEN')), revision INTEGER NOT NULL CHECK(revision>0), failure_count INTEGER NOT NULL CHECK(failure_count>=0), cooldown_until INTEGER, probe_generation INTEGER NOT NULL CHECK(probe_generation>=0), probe_owner TEXT, probe_deadline INTEGER);
CREATE TABLE retry_window(window_id INTEGER PRIMARY KEY, primary_attempts INTEGER NOT NULL CHECK(primary_attempts>=0), extra_attempts INTEGER NOT NULL CHECK(extra_attempts>=0));
CREATE TABLE control_receipts(actor TEXT NOT NULL, operation TEXT NOT NULL, target TEXT NOT NULL, request_key TEXT NOT NULL, request_digest TEXT NOT NULL, response_json TEXT NOT NULL CHECK(json_valid(response_json)), PRIMARY KEY(actor,operation,target,request_key));
CREATE TABLE operator_audit(sequence INTEGER PRIMARY KEY CHECK(sequence>0), actor TEXT NOT NULL, event_type TEXT NOT NULL, policy_id TEXT, payload_json TEXT NOT NULL CHECK(json_valid(payload_json)));
CREATE TABLE metrics_windows(window_id INTEGER PRIMARY KEY, counters_json TEXT NOT NULL CHECK(json_valid(counters_json)), histograms_json TEXT NOT NULL CHECK(json_valid(histograms_json)));
CREATE INDEX active_permits ON permits(state,route_id,upstream_id,owner_instance);
CREATE INDEX permit_due ON permits(deadline) WHERE state='ACTIVE';
-- Local per-process cache reference (may be implemented in bounded memory instead).
CREATE TABLE cache_entries(cache_key TEXT PRIMARY KEY, policy_id TEXT NOT NULL, generation INTEGER NOT NULL CHECK(generation>0), body BLOB NOT NULL CHECK(length(body)<=65536), headers_json TEXT NOT NULL CHECK(json_valid(headers_json)), fresh_until INTEGER NOT NULL, stale_until INTEGER NOT NULL, CHECK(stale_until>=fresh_until));
CREATE TABLE refresh_leases(cache_key TEXT PRIMARY KEY, owner_instance TEXT NOT NULL, generation INTEGER NOT NULL CHECK(generation>0), deadline INTEGER NOT NULL);
-- Domain guards enforce bucket migration, all-or-none hierarchical debits,
-- shared permit limits, current probe/refresh authority and privacy eligibility.
-- Add immutable-policy/receipt triggers in actual migrations.
