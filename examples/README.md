# Worked examples

These fictional examples make the contracts concrete. Replace illustrative IDs with returned runtime identities; use a stable Idempotency-Key for the same mutation intent. No file contains a live authority token or invented fixture digest.

| Example | Schema | Meaning |
| --- | --- | --- |
| [catalogue-policy.json](catalogue-policy.json) | [route-policy](../schemas/route-policy.schema.json) | Illustrative complete safe-GET route; cache/retry legality also requires semantic validation. |
| [policy-document.json](policy-document.json) | [policy-document](../schemas/policy-document.schema.json) | Publish the whole validated document and activate it atomically. |
| [activate-policy.json](activate-policy.json) | [activate](../schemas/activate.schema.json) | Target policy version is in the path; supply a stable operator key. |
| [register-upstream.json](register-upstream.json) | [upstream](../schemas/upstream.schema.json) | Only task-owned registered loopback fixtures can become forwarding targets. |
| [unsafe-mutation-policy.json](unsafe-mutation-policy.json) | [route-policy](../schemas/route-policy.schema.json) | No automatic mutation retry even if the client supplied an idempotency header. The inherited optional cache configuration is inactive because cachePublic=false. |
| [quota-rejection.json](quota-rejection.json) | [decision-sample](../schemas/decision-sample.schema.json) | Illustrative result, not a measured latency sample. Rejected work is excluded from application goodput. |
| [delayed-fixture.json](delayed-fixture.json) | [fixture-scenario](../schemas/fixture-scenario.schema.json) | Explicit test mode only; a one-second request deadline cannot be reset to accommodate this delay. |
| [capacity-assumptions.json](capacity-assumptions.json) | [capacity-input](../schemas/capacity-input.schema.json) | Analytical assumptions only; measured per-node fields are deliberately absent until an actual run exists. |

Run the analytical calculator with `node examples/capacity-model.mjs examples/capacity-assumptions.json`. It reports assumption-based arithmetic, not measured or validated deployment capacity. Node is a documentation-companion tool, not a required product backend.

Large fixture generators, independent expected digests and actual load results remain runtime implementation deliverables.
