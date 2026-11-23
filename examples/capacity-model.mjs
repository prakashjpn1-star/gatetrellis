// Analytical companion only. No network requests or load generation.
import fs from 'node:fs';
const a=JSON.parse(fs.readFileSync(process.argv[2]||new URL('./capacity-assumptions.json',import.meta.url),'utf8'));
for(const [k,v]of Object.entries(a))if(typeof v!=='number'||!Number.isFinite(v)||v<0)throw new Error('Invalid numeric assumption: '+k);
if(!(a.population>0&&a.usableFraction>0&&a.usableFraction<=1&&Number.isInteger(a.failureReserveNodes)))throw new Error('Invalid population, headroom or reserve');
const o={classification:'ANALYTICAL ASSUMPTIONS; NOT A BENCHMARK'};
const positive=k=>{if(!(a[k]>0))throw new Error(k+' must be positive');return a[k];};
if(a.arrivalWindowSeconds!==undefined)o.averageArrivalAttemptsPerSecond=a.population/positive('arrivalWindowSeconds');
if(a.pollIntervalSeconds!==undefined)o.averageStatusRequestsPerSecond=a.population/positive('pollIntervalSeconds');
if(a.updateBytes!==undefined)o.applicationEgressBytesPerSecond=a.population*positive('updateBytes')*positive('updatesPerSecond');
if(a.connectionStateBytes!==undefined)o.applicationConnectionStateBytes=a.population*positive('connectionStateBytes');
if(a.reconnectFraction!==undefined){if(a.reconnectFraction>1)throw new Error('reconnectFraction exceeds one');o.reconnectAttemptsPerSecond=a.population*a.reconnectFraction/positive('reconnectWindowSeconds');}
if(a.requestsPerMinute!==undefined){o.incomingRequestsPerSecond=positive('requestsPerMinute')/60;o.applicationEgressBytesPerSecond=o.incomingRequestsPerSecond*positive('responseBytes');if(a.cacheHitFraction!==undefined){if(a.cacheHitFraction>1)throw new Error('cacheHitFraction exceeds one');o.assumedOriginPrimariesPerSecond=o.incomingRequestsPerSecond*(1-a.cacheHitFraction);}}
if(o.applicationEgressBytesPerSecond!==undefined)o.applicationEgressGbitPerSecond=o.applicationEgressBytesPerSecond*8/1e9;
const limits=[];
if(a.measuredPerNodeRequestsPerSecond!==undefined){const demand=o.incomingRequestsPerSecond??o.averageStatusRequestsPerSecond??o.averageArrivalAttemptsPerSecond;if(demand!==undefined)limits.push(Math.ceil(demand/(positive('measuredPerNodeRequestsPerSecond')*a.usableFraction)));}
if(a.measuredPerNodeEgressBytesPerSecond!==undefined&&o.applicationEgressBytesPerSecond!==undefined)limits.push(Math.ceil(o.applicationEgressBytesPerSecond/(positive('measuredPerNodeEgressBytesPerSecond')*a.usableFraction)));
if(a.measuredPerNodeConnections!==undefined)limits.push(Math.ceil(a.population/(positive('measuredPerNodeConnections')*a.usableFraction)));
o.partialNodeLowerBound=limits.length?Math.max(...limits)+a.failureReserveNodes:null;
o.limitations='Partial lower bound only; absent CPU/memory/socket/network/shared-state measurements prevent a full node count. Overhead, skew, failure and non-linear scaling require separate evidence.';
console.log(JSON.stringify(o,null,2));
