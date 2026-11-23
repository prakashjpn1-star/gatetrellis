# Low-level designs

Each service owns one state transition boundary. Read [transactions](transactions.md) and [state machines](state-machines.md) first.

- [Policy validation activation and route matching](policies.md)
- [Atomic hierarchical token buckets](quotas.md)
- [Shared permits queues and tenant isolation](bulkheads.md)
- [Balancing health and coordinated circuit probes](origins.md)
- [Deadlines safe retries and disconnect cleanup](deadlines.md)
- [Public cache keys refresh collapse and fencing](cache.md)
- [Decision accounting goodput and bounded traces](measurement.md)
- [Storage](storage.md)
- [Browser and API modules](browser.md)
- [Observability](observability.md)

Contracts and examples are linked from the [documentation guide](../README.md).
