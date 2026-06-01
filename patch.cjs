// Patches index.mjs for Railway compatibility:
// 1. Fixes Express 5 wildcard route (path-to-regexp v8 incompatibility)
// 2. Adds SSL to PostgreSQL pool (Railway requires SSL)
const fs = require('fs');
let content = fs.readFileSync('./index.mjs', 'utf8');
const original = content;

// --- Fix 1: Express 5 wildcard route ---
content = content.split('app.get("*"').join('app.get(/.*/ ');
content = content.split('app.get("{.*}"').join('app.get(/.*/ ');
content = content.split('app.get("(.*)"').join('app.get(/.*/ ');
content = content.split('app.get(/.*/),').join('app.get(/.*/, ');

// --- Fix 2: SSL for Railway PostgreSQL ---
if (!content.includes('rejectUnauthorized')) {
  content = content.replace(
    /connectionString:\s*process\.env\.DATABASE_URL\s*\n(\s*)\}/,
    'connectionString: process.env.DATABASE_URL,\n$1  ssl: { rejectUnauthorized: false }\n$1}'
  );
}

if (content !== original) {
  fs.writeFileSync('./index.mjs', content);
  const hasRoute = content.includes('app.get(/.*/')
  const hasSsl = content.includes('rejectUnauthorized');
  console.log('[patch] Applied fixes - route:', hasRoute ? 'OK' : 'WARN', '| SSL:', hasSsl ? 'OK' : 'WARN');
} else {
  console.log('[patch] No changes needed');
}
