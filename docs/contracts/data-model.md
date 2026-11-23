# Data model and integrity

Current state, immutable accepted outcomes and audit records agree at each committed transition.

## Logical state and persistence

| Entity | Required content |
| --- | --- |
| RoutePolicyVersion | Immutable validated document/digest and publication metadata. |
| ActivePolicy | Revision-checked active version reference. |
| UpstreamRegistry | Loopback target ID, capabilities, capacity and drain state. |
| TokenBucket | Scoped key, units/refill timestamp and policy migration state. |
| ConcurrencyPermit | Request/attempt identity, scope, owner, lease/deadline and released outcome. |
| CircuitState | Scope, observations, phase/cooldown and probe authority. |
| CacheEntry/RefreshLease | Key/version, bounded response metadata/body, freshness and fenced refresh ownership. |
| ControlReceipt | Unique actor/operation/target/key and immutable accepted result. |
| MetricsWindow | Aggregated counters/histograms, labelled actual load and sampled request traces. |
| AuditEvent | Ordered operator/policy transitions and important failure decisions. |

The gateway need not persist every successful data-plane request forever; bounded metrics and sampled traces avoid making logging the bottleneck. Control receipts and policy history remain durable. Quota/concurrency recovery must document which state is durable and how restart avoids granting extra authority. Explicit nonnull IDs, unique scoped keys and bounded values are required.
