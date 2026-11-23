# Local access boundaries

The following release contracts apply to the local product and its operating environment.

## Failure handling and operations

Gateway restart must load the last active complete policy, recover or conservatively expire old permits and preserve control receipts. Coordination outage has an explicit route-level safe behaviour; no accidental quota bypass. Cache may be cold after restart, but cache-miss recovery stays bounded.

Stop fixture/gateway processes through tracked task-owned PIDs only. Graceful drain stops admission and finishes bounded in-flight work. Hard-kill tests preserve commit uncertainty. Explicit schema migrations refuse incompatible state and never reset the store silently. Consistent backup/restore includes policy versions, active pointer, receipts and coordination state needed for conservative recovery; old owner epochs cannot become fresh after restore.

Local security is ordinary application access control: loopback binding, Host/Origin checks, fictional roles, disposable demo tokens if necessary, bounded payloads and escaped UI text. No real credentials, external traffic, offensive security work or live customer data is involved.
