// Patches index.mjs: fixes ALL invalid Express 5 wildcard route patterns
const fs = require('fs');
let content = fs.readFileSync('./index.mjs', 'utf8');
const original = content;

// Fix string patterns: replacement does NOT include closing ')' because
// the original code still has ,handler) after the pattern we're replacing.
content = content.split('app.get("*"').join('app.get(/.*/ ');
content = content.split('app.get("{.*}"').join('app.get(/.*/ ');
content = content.split('app.get("(.*)"').join('app.get(/.*/ ');

// Fix previously-botched replacement that added an extra closing paren:
// app.get(/.*/),handler)  =>  app.get(/.*/, handler)
content = content.split('app.get(/.*/),').join('app.get(/.*/, ');

if (content !== original) {
  fs.writeFileSync('./index.mjs', content);
  console.log('[patch] Fixed wildcard route - server starting');
} else {
  console.log('[patch] No fix needed');
}
