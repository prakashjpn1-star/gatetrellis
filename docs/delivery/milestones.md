# Delivery milestones and release gate

The following release contracts apply to the local product and its operating environment.

## Milestones and delivery

| Milestone | Exit condition |
| --- | --- |
| 1 | Verify tools; real local HTTP fixtures, browser/readiness and control schemas work. |
| 2 | Route matching, immutable policy and actual forwarding pass contracts. |
| 3 | Multi-process quotas, permits and bounded queues pass atomicity tests. |
| 4 | Deadlines, cancellation and safe retry budget pass failure scenarios. |
| 5 | Health balancing, circuit probes and drain recover correctly. |
| 6 | Public caching, key isolation and refresh-collapse tests pass. |
| 7 | Operator UI and actual open-loop local load generator are complete. |
| 8 | Run overload/soak/crash/offline/restore suites and produce a defensible capacity report. |

Milestones may span multiple sessions. Deliver source/licence notices, local scripts, route/policy schemas, protocol contracts, fixture upstreams, browser UI, test/load harness, actual acceptance evidence, measurements, capacity calculations and continuation notes. Completion requires no unresolved defect violating admission, privacy, retry or bounded-resource contracts; a modeled global rate alone is insufficient.
