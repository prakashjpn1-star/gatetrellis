# Transaction and authority protocol

Every request pins one complete policy version. Shared quotas, finite permits and bounded queues apply across gateway processes; mutation timeouts never trigger automatic unsafe retries.

## Accepting operation

1. Bound bytes, parse strict JSON and prepare canonical content outside a write transaction.
2. Begin the write transaction before reading mutable shared limits or authority.
3. Look up scoped operation receipt. Matching content returns original evidence; changed content conflicts.
4. Reload aggregate state, current generation/revision, database time and all affected capacity/quantity conditions.
5. Apply one conditional transition; update associated accounting, audit sequence and receipt in the same transaction.
6. Commit before confirmation. Network delivery is a separate action with explicit uncertainty.

The decisive conditional update is the linearization point if its transaction commits. Equality to a deadline means expired. Read database UTC milliseconds after writer acquisition and immediately before time-sensitive writes. Commit response time is not the authority check time. Process monotonic clocks are suitable for local duration/send safety but do not replace durable due timestamps.

## Lock order conflicts and retries

Access receipt, parent release/policy/room, sorted child IDs, shared accounting/authority, outcome, audit, then receipt insertion. SQLite serializes writers; the order keeps dependencies reviewable. No filesystem/network wait, browser interaction or upstream work holds the writer.

Roll back a whole busy/conflicted transaction and retry within a bounded budget, retaining its key. Proposed backoff is 10/25/50/100/200 ms outside the writer, within two seconds or the stricter remaining request deadline. A failed COMMIT response is uncertain: discard connection and resolve through a fresh receipt lookup. Never repeat only a transaction suffix.

Read related state and bounds in one short snapshot. Shared admission is checked through canonical counts/balances, not process-local counters. Expired unclosed grants count conservatively until settlement. Failed transactions allocate no visible audit/feed sequence.

## Enforcement limits

NOT NULL identities, foreign keys, unique logical keys, partial unique active records and nonnegative/bounded CHECK constraints support the proof. State/time/revision transitions still require domain guards and immutable-field triggers in real migrations. CHECK expressions with NULL must not accidentally permit absent mandatory fields. Permit authority bounds gateway-authorized attempts, not all work a noncooperative origin might keep executing.
