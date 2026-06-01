// Patches index.mjs: fixes ALL invalid Express 5 wildcard route patterns
// Express 5 (path-to-regexp v8) rejects "*", "{.*}", and "(.*)" string patterns.
// The only fix: replace with a JavaScript regex /.*/ which Express 5 DOES support.
const fs = require('fs');
let content = fs.readFileSync('./index.mjs', 'utf8');
const original = content;

// Fix all known broken patterns -> app.get(/.*/
content = content.split('app.get("*"').join('app.get(/.*/)');
content = content.split('app.get("{.*}"').join('app.get(/.*/)');
content = content.split('app.get("(.*)"').join('app.get(/.*/)');

if (content !== original) {
  fs.writeFileSync('./index.mjs', content);
  console.log('[patch] Fixed: replaced invalid wildcard route with regex /.*/');
} else if (content.includes('app.get(/.*/)')) {
  console.log('[patch] Regex /.*/ already present - OK');
} else {
  console.log('[patch] WARNING: No wildcard pattern found to fix!');
}
