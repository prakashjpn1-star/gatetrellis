# State machines and race outcomes

```mermaid
stateDiagram-v2
    [*] --> RECEIVED
    RECEIVED --> VALIDATED
    VALIDATED --> QUOTA_CHECKED
    QUOTA_CHECKED --> CACHE_CHECKED
    CACHE_CHECKED --> COMPLETED: permitted hit
    CACHE_CHECKED --> WAITING_CAPACITY: bounded useful wait
    WAITING_CAPACITY --> FORWARDED: permits and time remain
    FORWARDED --> COMPLETED
    FORWARDED --> TIMED_OUT
    RECEIVED --> REJECTED: invalid request
    QUOTA_CHECKED --> REJECTED: denied quota
    WAITING_CAPACITY --> REJECTED: overload
    FORWARDED --> CANCELLED: client disconnect
    COMPLETED --> [*]
    REJECTED --> [*]
    TIMED_OUT --> [*]
    CANCELLED --> [*]
```

```mermaid
stateDiagram-v2
    [*] --> CLOSED
    CLOSED --> OPEN: threshold reached
    OPEN --> HALF_OPEN: cooldown and probe grant
    HALF_OPEN --> CLOSED: bounded successful probes
    HALF_OPEN --> OPEN: probe fails
```

Additional states and transition guards are in the [software requirements](../requirements/software.md). Terminal records do not reopen; receipt replay proves a former commit without making a new transition.

| Race | Outcome |
| --- | --- |
| Completion versus deadline | Only a serialized transition with valid current authority can newly commit. |
| New control versus new work | The first valid committed transition determines admission under the pinned/current-state rules. |
| Two workers settle one due record | One conditional transition wins; the other records no duplicate terminal event. |
| Commit versus lost response | Replay original identity/key; transport timeout does not imply rollback. |
| Lowered limits versus occupancy | Existing valid occupancy drains; no new grant exceeds the effective admission rule. |
