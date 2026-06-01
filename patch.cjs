// Safety patch - index.mjs is pre-fixed, this just logs confirmation
const fs = require('fs');
const content = fs.readFileSync('./index.mjs', 'utf8');
const hasRoute = content.includes('app.get(/.*/')
const hasSsl = content.includes('rejectUnauthorized');
console.log('[patch] route:', hasRoute ? 'OK' : 'MISSING', '| ssl:', hasSsl ? 'OK' : 'MISSING');
if (!hasRoute || !hasSsl) process.exit(1);
