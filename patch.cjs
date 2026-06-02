const fs = require('fs');
const content = fs.readFileSync('./index.mjs', 'utf8');
const hasRoute = content.includes('app.get(/.*/')
const hasSsl = content.includes('rejectUnauthorized');
console.log('[patch] route:', hasRoute ? 'OK' : 'MISSING', '| ssl:', hasSsl ? 'OK' : 'MISSING');
if (!hasRoute || !hasSsl) { console.error('[patch] FATAL: bundle missing required fixes'); process.exit(1); }
console.log('[patch] All checks passed.');
