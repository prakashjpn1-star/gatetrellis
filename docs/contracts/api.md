# API and protocol contracts

The API uses bounded requests, explicit outcomes and operation-scoped request identity. Protected authority stays out of query strings.

## API and local fixture contracts

| Endpoint | Behaviour |
| --- | --- |
| GET /api/health, /api/ready | Liveness separate from policy/store/fixture readiness. |
| POST /api/policies/drafts, /validate, /publish | Edit and publish complete immutable policy. |
| POST /api/policies/{id}/activate | Revision-checked keyed activation/rollback. |
| POST /api/upstreams | Register permitted loopback fixture. |
| POST /api/upstreams/{id}/drain | Stop new forwarding to target. |
| GET or POST /proxy/{route}/... | Actual local data-plane request with bounded contract. |
| GET /api/decisions, /api/metrics | Filtered sampled traces and aggregate outcomes. |
| GET /api/circuits, /api/quotas, /api/capacity | Current enforcement and age/authority details. |
| POST /test/scenarios | Explicit test-mode-only fixture latency/error control. |

Policy example: `{"route":"catalogue","methods":["GET"],"deadlineMs":1000,"maxInFlight":20,"maxQueue":40,"queueWaitMs":50,"retryMaxAdditionalAttempts":1,"cachePublic":true}`. Full schema also defines upstreams, bucket scopes and bounds.

Return 400/422 for malformed/invalid control content, 403 for denied demo role, 404 for unmatched route, 409 for stale control revision/key conflict, 413 for size rejection, 429 for quota denial, 502 for defined upstream failure, 503 for overload/unavailable coordination and 504 for deadline expiry where no response has started. Do not rewrite all failures into 200 responses. Explain unsupported streaming/partial-response cases explicitly.

## Contract companions

[JSON Schemas](../../schemas/README.md), [worked examples](../../examples/README.md) and [reference SQL](../../schemas/reference-schema.sql) make the proposed shapes explicit. Header/session identity and state-dependent checks remain the server’s responsibility.
