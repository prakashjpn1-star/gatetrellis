# Requirements traceability

Every source section and numbered requirement is retained. Coverage is planned verification, not a test pass.

| Source section | Active contract | Component |
| --- | --- | --- |
| 1 Purpose and intended product | [Read](../requirements/product.md) | Cross-component requirement |
| 2 Users and example workload | [Read](../requirements/product.md) | Cross-component requirement |
| 3 Fit and evidence boundaries | [Read](../requirements/product.md) | Cross-component requirement |
| 4 Scope | [Read](../requirements/product.md) | Cross-component requirement |
| 5 Reference demonstration | [Read](../requirements/product.md) | Cross-component requirement |
| 6 Policy and routing contract | [Read](../requirements/software.md) | [Policy validation activation and route matching](../design/policies.md) |
| 7 Request lifecycle and outcome classification | [Read](../requirements/software.md) | [Deadlines safe retries and disconnect cleanup](../design/deadlines.md) |
| 8 Rate limits and shared quotas | [Read](../requirements/software.md) | [Atomic hierarchical token buckets](../design/quotas.md) |
| 9 Capacity bulkheads and queueing | [Read](../requirements/software.md) | [Shared permits queues and tenant isolation](../design/bulkheads.md) |
| 10 Load balancing and upstream health | [Read](../requirements/software.md) | [Balancing health and coordinated circuit probes](../design/origins.md) |
| 11 Deadlines cancellation and retries | [Read](../requirements/software.md) | [Deadlines safe retries and disconnect cleanup](../design/deadlines.md) |
| 12 Public caching and stampede control | [Read](../requirements/software.md) | [Public cache keys refresh collapse and fencing](../design/cache.md) |
| 13 Logical state and persistence | [Read](../contracts/data-model.md) | Cross-component requirement |
| 14 API and local fixture contracts | [Read](../contracts/api.md) | Cross-component requirement |
| 15 Browser operator application | [Read](../requirements/browser-journeys.md) | Cross-component requirement |
| 16 Failure handling and operations | [Read](../security/local-access.md) | Cross-component requirement |
| 17 Measured desktop acceptance targets | [Read](../testing/performance-and-capacity.md) | [Decision accounting goodput and bounded traces](../design/measurement.md) |
| 18 Load methodology and scale arithmetic | [Read](../testing/performance-and-capacity.md) | [Decision accounting goodput and bounded traces](../design/measurement.md) |
| 19 Acceptance catalog | [Read](../testing/acceptance-plan.md) | Cross-component requirement |
| 20 Milestones and delivery | [Read](../delivery/milestones.md) | Cross-component requirement |
| 21 Open choices and primary references | [Read](../architecture/references.md) | Cross-component requirement |

## Numbered requirements including UI

| ID | Behavior | Design |
| --- | --- | --- |
| POL-01 | Define routes by validated method and path prefix, with deterministic priority and explicit ambiguity rejection. | [Component](../design/policies.md) |
| POL-02 | Upstreams reference operator-registered loopback targets; client-controlled destination URLs are never accepted. | [Component](../design/policies.md) |
| POL-03 | Publish an immutable policy version after complete validation; activation is atomic and revision checked. | [Component](../design/policies.md) |
| POL-04 | Each new request pins one policy version through its whole lifecycle. Hot reload cannot mix old quota with new retry/cache rules. | [Component](../design/policies.md) |
| POL-05 | Policies declare request/response limits, deadline, queue size/time, concurrency, quota, cache eligibility and retry rules. | [Component](../design/policies.md) |
| POL-06 | Invalid policy changes leave the prior version active. Rollback activates a prior valid version as an audited new control action. | [Component](../design/policies.md) |
| POL-07 | Lowering concurrency does not kill arbitrary active work or admit more work; existing occupancy drains until within the new limit. | [Component](../design/policies.md) |
| LIM-01 | Implement a documented token-bucket contract per configured synthetic tenant/route key, with refill rate r and burst B. | [Component](../design/quotas.md) |
| LIM-02 | Multi-process requests cannot each receive a full independent copy of a shared bucket. The accounting update is atomic. | [Component](../design/quotas.md) |
| LIM-03 | If hierarchical buckets apply, acceptance consumes all required buckets together or none; no partial debit on rejection. | [Component](../design/quotas.md) |
| LIM-04 | Use bounded integer/fixed-point arithmetic and one authoritative clock per shared accounting operation. | [Component](../design/quotas.md) |
| LIM-05 | A denied request returns 429 and bounded retry-after guidance without forwarding upstream. | [Component](../design/quotas.md) |
| LIM-06 | Missing/unavailable mandatory quota state returns an explicit unavailable decision, not unlimited forwarding. | [Component](../design/quotas.md) |
| LIM-07 | Policy revision and bucket migration preserve a documented budget; resetting a policy must not refill every bucket accidentally. | [Component](../design/quotas.md) |
| GW-UI-01 | Serve all pages, CSS, scripts and optional assets locally from the application origin; core console operation requires no internet. | [Browser](../design/browser.md) |
| GW-UI-02 | JavaScript is the dependency-minimal path. Optional TypeScript must compile with a compiler available through the permitted mirror, using a documented local command. Serve generated JavaScript; no runtime compilation or remote package fetch is required. | [Browser](../design/browser.md) |
| GW-UI-03 | A small HTML/CSS/JavaScript module layout is sufficient. A frontend framework/build system is optional and must pass the dependency gate if selected. | [Browser](../design/browser.md) |
| GW-UI-04 | Policy validation, activation and target controls call actual APIs, preserve expected revisions and show confirmed server outcomes or conflicts. | [Browser](../design/browser.md) |
| GW-UI-05 | Poll bounded aggregate metrics at a documented interval; limit sampled rows and pause unnecessary background refresh. The browser dashboard is not the high-rate load generator. | [Browser](../design/browser.md) |
| GW-UI-06 | Provide labels, keyboard controls, text status and request errors. Enforce roles, target allowlists and load caps on the backend regardless of browser controls. | [Browser](../design/browser.md) |

## Acceptance cases

| ID | Oracle | Outcome |
| --- | --- | --- |
| GW-AC-01 | Validate route/policy and reject ambiguous or invalid configuration without replacing the active version. | NOT RUN |
| GW-AC-02 | Concurrent policy activation pins each request to one complete version. | NOT RUN |
| GW-AC-03 | Two gateway processes enforce shared token bounds under deterministic and concurrent traces. | NOT RUN |
| GW-AC-04 | Hierarchical limit failure consumes no partial quota and forwards nothing. | NOT RUN |
| GW-AC-05 | Quota-state outage fails closed on protected forwarding with a clear unavailable outcome. | NOT RUN |
| GW-AC-06 | Global/route/upstream permits and pending queues remain within declared bounds. | NOT RUN |
| GW-AC-07 | A noisy tenant does not starve the configured protected low-volume share. | NOT RUN |
| GW-AC-08 | Queue and retry time count against the original deadline; no expired request is forwarded. | NOT RUN |
| GW-AC-09 | Safe GET retry obeys allowlist, deadline, maximum attempts and amplification budget. | NOT RUN |
| GW-AC-10 | Fake mutation times out after origin side effect; gateway does not automatically retry it. | NOT RUN |
| GW-AC-11 | Unhealthy target opens circuit and coordinated half-open probes remain bounded. | NOT RUN |
| GW-AC-12 | Target recovery/drain changes routing without unlimited failover traffic. | NOT RUN |
| GW-AC-13 | Public cache respects key/version and explicit freshness; private/cookie/authorization data bypasses sharing. | NOT RUN |
| GW-AC-14 | Hot-key miss collapse stays within documented per-process or global refresh scope and waiter bounds. | NOT RUN |
| GW-AC-15 | Stale refresh cannot overwrite newer content/policy generation. | NOT RUN |
| GW-AC-16 | Client disconnect and gateway kill do not leak or double-release permits; orphan-work limits are reported honestly. | NOT RUN |
| GW-AC-17 | Cache/coordination restart produces bounded cold-start behaviour, not an unbounded origin stampede. | NOT RUN |
| GW-AC-18 | Actual open-loop profile reconciles every offered request and identifies generator saturation. | NOT RUN |
| GW-AC-19 | Overload profile reports goodput, all outcomes and queue bounds rather than only successful-response p95. | NOT RUN |
| GW-AC-20 | Operator browser activation/inspection/stale tabs, keyboard and error states work. | NOT RUN |
| GW-AC-21 | Nonlocal target, oversized bodies, unexpected origin and unauthorized control are rejected. | NOT RUN |
| GW-AC-22 | Consistent restore recovers complete policy/receipts and cannot revive stale permit authority. | NOT RUN |
| GW-AC-23 | Thirty-minute bounded soak and offline end-to-end operation pass with measured resources. | NOT RUN |
| GW-AC-24 | Scale report clearly separates actual HTTP throughput, million-request totals and 10-million/minute hypotheses. | NOT RUN |
| GW-AC-25 | Basic HTML/CSS/JS or compiled-TS console loads with only local assets and performs policy validation/activation, sample requests, diagnostics and bounded scenario controls against real APIs, including stale/error and keyboard flows; optional TypeScript compilation works through the permitted local toolchain. | NOT RUN |
