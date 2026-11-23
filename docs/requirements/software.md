# Software requirements

Every request pins one complete policy version. Shared quotas, finite permits and bounded queues apply across gateway processes; mutation timeouts never trigger automatic unsafe retries.

## Policy and routing contract

| ID | Requirement |
| --- | --- |
| POL-01 | Define routes by validated method and path prefix, with deterministic priority and explicit ambiguity rejection. |
| POL-02 | Upstreams reference operator-registered loopback targets; client-controlled destination URLs are never accepted. |
| POL-03 | Publish an immutable policy version after complete validation; activation is atomic and revision checked. |
| POL-04 | Each new request pins one policy version through its whole lifecycle. Hot reload cannot mix old quota with new retry/cache rules. |
| POL-05 | Policies declare request/response limits, deadline, queue size/time, concurrency, quota, cache eligibility and retry rules. |
| POL-06 | Invalid policy changes leave the prior version active. Rollback activates a prior valid version as an audited new control action. |
| POL-07 | Lowering concurrency does not kill arbitrary active work or admit more work; existing occupancy drains until within the new limit. |

A control-store outage uses the last completely activated immutable policy for supported reads, but unavailable required quota/permit coordination fails closed for new protected forwarding. Do not silently switch global quotas to per-process quotas.

## Request lifecycle and outcome classification

Lifecycle is RECEIVED, VALIDATED, QUOTA_CHECKED, CACHE_CHECKED, WAITING_CAPACITY where permitted, FORWARDED, then COMPLETED, REJECTED, TIMED_OUT or CANCELLED. Retries are child attempts of one client request and preserve its original absolute deadline.

Every request has a gateway correlation ID, synthetic tenant, route/policy version and final category. Categories distinguish malformed input, quota rejection, overload rejection, circuit open, upstream timeout, upstream error, cache result, successful forwarding and client disconnect. A rejected request is not successful application goodput.

Validation bounds bytes before expensive parsing. No request is queued indefinitely or dispatched after its deadline. Admission and cache policies are explicit: synthetic tenant quotas count all requests, including cache hits; upstream concurrency applies only to forwarded attempts.

## Rate limits and shared quotas

| ID | Requirement |
| --- | --- |
| LIM-01 | Implement a documented token-bucket contract per configured synthetic tenant/route key, with refill rate r and burst B. |
| LIM-02 | Multi-process requests cannot each receive a full independent copy of a shared bucket. The accounting update is atomic. |
| LIM-03 | If hierarchical buckets apply, acceptance consumes all required buckets together or none; no partial debit on rejection. |
| LIM-04 | Use bounded integer/fixed-point arithmetic and one authoritative clock per shared accounting operation. |
| LIM-05 | A denied request returns 429 and bounded retry-after guidance without forwarding upstream. |
| LIM-06 | Missing/unavailable mandatory quota state returns an explicit unavailable decision, not unlimited forwarding. |
| LIM-07 | Policy revision and bucket migration preserve a documented budget; resetting a policy must not refill every bucket accidentally. |

For a bucket initially full, accepted unit-cost requests over an interval must respect its declared r/B accounting semantics, verified with deterministic clock tests and concurrent operations. Backend client retries are separate upstream attempts and use a separate retry budget; they cannot create free unlimited upstream work.

The initial reference protocol may centralize atomic quota decisions. That is a known scaling limit. Any proposed production partitioning or preallocated budgets must specify key ownership, failure handling and a rigorous aggregate bound. Do not assume arbitrary distributed token leases preserve the same instantaneous rate bound.

## Capacity bulkheads and queueing

Global, route and upstream concurrency are finite. Acquire required permits atomically or with a tested no-leak protocol before forwarding. Limits protect gateway-authorized attempts; they do not magically stop arbitrary downstream work that survives a lost connection.

Pending queues are bounded by count and bytes, with a maximum waiting duration, initially 50 ms. A request waits only if useful service can plausibly finish within its remaining deadline. Otherwise reject early with 503 overload and documented retry guidance. Health/administration has separate small capacity so diagnostics survive overload.

An active attempt holds its permit until upstream transport has closed or a documented conservative lease/deadline rule makes orphan authority safe. Cancellation requests alone are not proof the upstream stopped. Cooperative local fixtures observe cancellation and deadlines; noncooperative-origin limits must be reported separately. Crash recovery never releases the same permit twice or silently multiplies capacity across gateway replicas.

Isolate synthetic tenants with explicit bounded shares or fair queue scheduling. State the fairness rule and measure starvation; strict global request FIFO is not required. Protect a small low-volume route from a burst on another route using separate bulkheads.

## Load balancing and upstream health

Select among compatible registered upstreams by a deterministic documented policy, such as least authorized in-flight with a stable tie-breaker. Respect per-upstream capacity, readiness and draining status. A draining target receives no new requests but may finish existing work.

Passive errors and bounded active health checks influence routing. Circuit states are CLOSED, OPEN and HALF_OPEN. Opening/closing thresholds, observation windows and cooldowns are explicit. Across gateway processes, half-open probe permission is coordinated so a recovering service is not flooded by one probe per waiting request.

At least one path must demonstrate recovery from a stopped/unhealthy fixture. A single hot route cannot shift unlimited traffic to another upstream just because its first target failed. Health checks have their own small retry/concurrency budget.

## Deadlines cancellation and retries

Every request has a finite gateway absolute deadline; default local profile is 1 second. Connect, queue, each attempt and retry delay all consume this budget. Do not reset the deadline on failover. Propagate remaining budget to cooperative fixtures and stop forwarding when no useful time remains.

Only explicitly safe GET/HEAD routes may automatically retry in the first release, at most one additional attempt and only before response bytes have been committed to the client. Mutation requests are not retried merely because an idempotency header exists. Extending retry support requires a verified origin idempotency contract and new tests.

Retryable connection failures/status codes are allowlisted. Apply bounded jitter and a shared retry budget, initially no more than 10 extra attempts per 100 primary upstream attempts over a documented window. Circuit-open, quota rejection and exhausted deadlines do not trigger immediate loops. A retry consumes concurrency and is counted in amplification metrics.

A client disconnect triggers cancellation/cleanup; the request outcome records uncertainty if the origin might have committed a side effect. Never fabricate a success or assert a downstream rollback from a connection close.

## Public caching and stampede control

Cache only explicitly eligible public GET responses from local fixture routes. Bypass requests with authorization/cookies or personalized context, and bypass responses marked private/no-store or containing session-setting headers. Include route/policy generation, normalized path/query and supported Vary dimensions in the cache key. Unknown Vary values bypass caching.

Respect configured origin freshness and validators for the supported subset; document that this is a constrained gateway cache, not full HTTP cache compliance. Initially cache only 200 responses below 64 KiB, with bounded total bytes and deterministic eviction. Do not cache errors, mutations or response bodies exceeding the cap.

Collapse concurrent misses for the same key into one refresh per gateway cache owner; bound waiters and their deadlines. If caches are per process, document up to one refresh per process rather than falsely claiming one cluster-wide fetch. The reference shared-key lease protocol may reduce this to one global refresh if implemented and tested. Expired refresh authority cannot overwrite a newer cache generation.

Serving stale public data is allowed only by an explicit route rule with a finite stale window and a visible response/metric indicator. It must not bypass privacy checks or claim fresh success. Cache invalidation includes policy version and fixture content revision so a control change cannot expose old incompatible data.
