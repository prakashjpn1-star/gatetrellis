# Design review and open questions

The first release is a real local product with a separate large-scale capacity study. Its success depends on shared-state and recovery evidence rather than a headline traffic count.

| Risk | Design response |
| --- | --- |
| Policy changes can accidentally reset shared bucket budgets. | Addressed in the component algorithms and acceptance plan; runtime proof remains pending. |
| A client timeout does not prove an origin mutation rolled back. | Addressed in the component algorithms and acceptance plan; runtime proof remains pending. |
| Per-process cache collapse is not cluster-wide single-flight. | Addressed in the component algorithms and acceptance plan; runtime proof remains pending. |
| Permit expiry bounds authority, not arbitrary noncooperative origin CPU work. | Addressed in the component algorithms and acceptance plan; runtime proof remains pending. |

The reference architecture resolves the language direction to Python, local transactional SQLite and a basic HTML/CSS/JavaScript frontend. Exact framework/driver/canonicalizer versions require permitted-environment verification. New algorithm defaults are explicitly proposed in their design pages.

No multi-million deployment, production bot resistance, arbitrary-origin rollback or cross-region consistency is established by the local design. Original inputs are archived for traceability. AI assistance and programme eligibility remain separate from participant-authored submission answers.
