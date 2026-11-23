# Browser journeys and basic UI

The basic browser is a working product deliverable. Its controls use actual local APIs; charts and countdowns explain server state rather than create authority.

## Browser operator application

Screens include route/policy editor with validation and activation diff; gateway/upstream health; offered/admitted/completed request charts; quota/circuit/capacity views; cache hit/miss/refresh view; sampled decision timeline; and controlled local scenario runner.

Show request rate and useful goodput separately. Show all latency outcomes and rejections; a low p95 achieved by rejecting almost every request is not a success. Distinguish simulated arrivals from real completed HTTP requests. Include policy version on traces, permission errors, stale edit conflicts, loading/disconnected states and keyboard-accessible tables.

The scenario UI operates only allowlisted fixture processes. It cannot enter arbitrary public URLs or initiate unbounded traffic. Test mode is visibly enabled and disabled by default.

### Basic HTML and JavaScript or TypeScript UI

A basic working UI is a mandatory release deliverable. Use semantic HTML, ordinary CSS and plain JavaScript, or TypeScript compiled to browser JavaScript. The backend language remains open. Native HTTP requests, simple tables, numeric summaries and optional small SVG charts cover the required console.

| Minimum view | Visible information and working controls |
| --- | --- |
| Routes and policies | Route table, policy JSON/form editor, validation errors, version/diff view and confirmed activation/rollback action. |
| Traffic dashboard | Offered/sent/admitted/completed rates, useful goodput, response categories, latency, cache status and policy version. |
| Upstreams and diagnostics | Target readiness/circuit/capacity table, drain control, quota reasons and bounded sampled request detail. |
| Local scenario panel | Allowlisted fixture selector, bounded test profile, start/stop and clear test-mode status. |

| ID | Basic UI requirement |
| --- | --- |
| GW-UI-01 | Serve all pages, CSS, scripts and optional assets locally from the application origin; core console operation requires no internet. |
| GW-UI-02 | JavaScript is the dependency-minimal path. Optional TypeScript must compile with a compiler available through the permitted mirror, using a documented local command. Serve generated JavaScript; no runtime compilation or remote package fetch is required. |
| GW-UI-03 | A small HTML/CSS/JavaScript module layout is sufficient. A frontend framework/build system is optional and must pass the dependency gate if selected. |
| GW-UI-04 | Policy validation, activation and target controls call actual APIs, preserve expected revisions and show confirmed server outcomes or conflicts. |
| GW-UI-05 | Poll bounded aggregate metrics at a documented interval; limit sampled rows and pause unnecessary background refresh. The browser dashboard is not the high-rate load generator. |
| GW-UI-06 | Provide labels, keyboard controls, text status and request errors. Enforce roles, target allowlists and load caps on the backend regardless of browser controls. |

Frontend acceptance is functional: a reviewer can inspect a route, validate and activate a policy, send a sample local request, run a bounded fixture scenario and see the resulting quota/overload/cache decisions. Display measured and modeled rates in separately labelled fields so the simple dashboard cannot imply a production benchmark.
