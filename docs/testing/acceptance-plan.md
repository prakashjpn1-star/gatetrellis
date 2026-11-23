# Acceptance and failure scenarios

These are planned runtime oracles. Every case begins NOT RUN.

## Acceptance catalog

| ID | Scenario and required oracle |
| --- | --- |
| GW-AC-01 | Validate route/policy and reject ambiguous or invalid configuration without replacing the active version. |
| GW-AC-02 | Concurrent policy activation pins each request to one complete version. |
| GW-AC-03 | Two gateway processes enforce shared token bounds under deterministic and concurrent traces. |
| GW-AC-04 | Hierarchical limit failure consumes no partial quota and forwards nothing. |
| GW-AC-05 | Quota-state outage fails closed on protected forwarding with a clear unavailable outcome. |
| GW-AC-06 | Global/route/upstream permits and pending queues remain within declared bounds. |
| GW-AC-07 | A noisy tenant does not starve the configured protected low-volume share. |
| GW-AC-08 | Queue and retry time count against the original deadline; no expired request is forwarded. |
| GW-AC-09 | Safe GET retry obeys allowlist, deadline, maximum attempts and amplification budget. |
| GW-AC-10 | Fake mutation times out after origin side effect; gateway does not automatically retry it. |
| GW-AC-11 | Unhealthy target opens circuit and coordinated half-open probes remain bounded. |
| GW-AC-12 | Target recovery/drain changes routing without unlimited failover traffic. |
| GW-AC-13 | Public cache respects key/version and explicit freshness; private/cookie/authorization data bypasses sharing. |
| GW-AC-14 | Hot-key miss collapse stays within documented per-process or global refresh scope and waiter bounds. |
| GW-AC-15 | Stale refresh cannot overwrite newer content/policy generation. |
| GW-AC-16 | Client disconnect and gateway kill do not leak or double-release permits; orphan-work limits are reported honestly. |
| GW-AC-17 | Cache/coordination restart produces bounded cold-start behaviour, not an unbounded origin stampede. |
| GW-AC-18 | Actual open-loop profile reconciles every offered request and identifies generator saturation. |
| GW-AC-19 | Overload profile reports goodput, all outcomes and queue bounds rather than only successful-response p95. |
| GW-AC-20 | Operator browser activation/inspection/stale tabs, keyboard and error states work. |
| GW-AC-21 | Nonlocal target, oversized bodies, unexpected origin and unauthorized control are rejected. |
| GW-AC-22 | Consistent restore recovers complete policy/receipts and cannot revive stale permit authority. |
| GW-AC-23 | Thirty-minute bounded soak and offline end-to-end operation pass with measured resources. |
| GW-AC-24 | Scale report clearly separates actual HTTP throughput, million-request totals and 10-million/minute hypotheses. |
| GW-AC-25 | Basic HTML/CSS/JS or compiled-TS console loads with only local assets and performs policy validation/activation, sample requests, diagnostics and bounded scenario controls against real APIs, including stale/error and keyboard flows; optional TypeScript compilation works through the permitted local toolchain. |

All outcomes start NOT RUN. Preserve commit/environment, workload schedule, fixture modes, request accounting, histograms, resource samples, receipts and invariant evidence. Repeat policy/quota/permit contention 100 rounds and critical crash/uncertain-response windows 20 times. Never regenerate an evidence report over recorded results.
