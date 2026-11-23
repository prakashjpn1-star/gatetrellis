# Measurements and capacity assumptions

Measured local throughput, simulated populations and analytical deployment targets are reported separately. Every stated target is provisional until measured.

## Measured desktop acceptance targets

Begin with a 100-real-request/second calibration. Provisional target is 1,000 offered small HTTP requests/second through 2 gateway processes against trivial local fixture reads, for 60 seconds, within available resources. Cache-hit and uncached profiles are measured separately; target is not automatically required of a deliberately slow backend.

Record p50/p95/p99 total latency, goodput, error categories, queue occupancy, permit occupancy, retry amplification, cache rate, bytes, generator start delay and CPU/RAM for every component. Provisional gateway-added p95 overhead on an unloaded fast fixture is <=20 ms; local UI update <=3 seconds; total service/store steady-state memory <=2 GiB excluding browser/generator/build. Calibrate upstream capacity before overload tests.

At two to five times calibrated useful backend capacity, queues remain bounded, the low-volume protected route retains its configured share, and admitted useful work does not collapse into timeouts solely because the gateway accepted unbounded demand. Report the measured comparison, not a promised universal latency bound.

## Load methodology and scale arithmetic

Use open-loop arrivals for overload and record scheduled versus actual start time to expose generator lag. A closed-loop client test may be supplementary but must not hide reduced offered traffic when latency rises. Reconcile offered count with generator-not-sent, actual sent and every final response/timeout/disconnect. Measure socket/pool reuse explicitly.

A long run may issue 1 million sequential/multiplexed local requests, but that count is not 1 million simultaneous users. Keep a resource/time cap and report incomplete runs honestly. Tests target only the local fixtures, use no system-wide network changes and stop before exhausting the desktop.

The architectural target 10,000,000 requests/minute equals about 166,667 requests/second. At 2 KiB response payload each, application response traffic alone is about 341.3 MB/second or 2.73 Gbit/second, excluding request traffic, HTTP/TLS overhead and retransmission. At a modeled 90 percent eligible cache-hit rate, average origin demand would be about 16,667 requests/second before refreshes/retries; cache eligibility, skew and misses make this an assumption, not evidence.

Capacity study must model hot keys, shared quota serialization, cache ownership, connection pools, failure reserve and egress separately. Derive node counts from measured sustainable CPU/network/connection limits with explicit utilization headroom. Identify operations that still serialize globally. Explain which higher-scale redesigns are unimplemented. Neither a central database transaction per request nor added gateway replicas is automatically a production-scale solution.
