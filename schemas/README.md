# Schema catalog

These draft-2020-12 JSON Schemas define proposed version 1 shapes. They complement the [API contracts](../docs/contracts/api.md); they are not a running service.

| Schema | Contract |
| --- | --- |
| [route-policy.schema.json](route-policy.schema.json) | Versioned complete route policy |
| [policy-document.schema.json](policy-document.schema.json) | Immutable multi-route policy document |
| [activate.schema.json](activate.schema.json) | Revision-checked policy activation |
| [upstream.schema.json](upstream.schema.json) | Registered fixture target |
| [fixture-scenario.schema.json](fixture-scenario.schema.json) | Bounded test-mode fixture scenario |
| [decision-sample.schema.json](decision-sample.schema.json) | Bounded data-plane decision sample |
| [capacity-input.schema.json](capacity-input.schema.json) | Explicit analytical capacity assumptions |

[reference-schema.sql](reference-schema.sql) defines principal relational keys, bounds and indexes. Real migrations must add checksums, immutable-field triggers and complete domain constraints. SQL setup alone does not prove concurrency/recovery.

JSON Schema does not verify database time, current owner/revision, cross-field arithmetic, loopback process ownership, encoded byte length or complete map/route semantics. Strict parsing rejects duplicate keys/nonfinite values and the domain service checks current state inside the transaction. Keys/session authority stay in headers/cookies; examples contain no live tokens.

Configured counts and schema maxima are proposed design limits pending permitted-environment checks and measurement. Ordinary list/page and endpoint byte limits follow the source contracts. Examples illustrate shape, not observed acceptance results.
