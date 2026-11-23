# Architecture decisions

## ADR 1 Local services and browser

The reference design uses Python, an ASGI-compatible HTTP runtime, SQLite and basic semantic HTML/CSS/JavaScript. A small API layer serves the UI and domain operations. Exact runtime/framework, schema validator and canonicalization versions remain pending permitted-environment inventory. Optional TypeScript needs a permitted offline compile command and committed/served JavaScript; the baseline needs no frontend framework.

## ADR 2 Shared transactional coordination

Explicit BEGIN IMMEDIATE mutations serialize shared state under SQLite WAL, FULL synchronous durability and foreign keys on each connection. Network I/O, streaming sends and handler work occur outside writers. This favors a reviewable local proof and creates a measurable throughput bottleneck. SQLite documents [write transactions](https://www.sqlite.org/lang_transaction.html); the product-level authority protocol remains application work.

## ADR 3 Identity and canonical content

Propose RFC 8785 canonical JSON and SHA-256 for immutable documents and request digests, verified against standard vectors before implementation. Keys are scoped by actor, operation and target. Repeated committed keys return original receipts; changed content conflicts. Runtime authority uses opaque disposable values with protected recovery storage, digest-only audit and explicit generation/expiry.

## ADR 4 Basic UI and transport

Use the runtime’s supported HTTP client/server implementation. Automatic HTTP-client retries are disabled; the domain attempt policy decides all retries. Public caching is a declared subset informed by [RFC 9111](https://www.rfc-editor.org/rfc/rfc9111.html), not a claim of complete HTTP cache compliance.

## ADR 5 Current state with atomic audit

Durable control/accepted business outcomes have transactional receipts and ordered audit. Per-frame/per-request telemetry is aggregated or sampled where the source allows it; logging must not become an unbounded data-plane dependency. Wall-clock timestamps are not ordering keys.

## Remaining decisions

Exact permitted packages/versions, calibrated byte/resource caps, configured retention and durable-token recovery keys require an environment record. These are implementation gates, not leftover instructions to write a proposal. No local measurement establishes the larger production target.
