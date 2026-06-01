// Patches index.mjs to fix Express 5 wildcard route incompatibility
const fs = require('fs');
let content = fs.readFileSync('./index.mjs', 'utf8');
const original = content;

// Fix original: app.get("*", ...) -> app.get("(.*)", ...)
content = content.split('app.get("*"').join('app.get("(.*)"');

// Fix broken sed result: app.get("{.*}", ...) -> app.get("(.*)", ...)
content = content.split('app.get("{.*}"').join('app.get("(.*)"');

if (content !== original) {
  fs.writeFileSync('./index.mjs', content);
  console.log('[patch] Fixed wildcard route -> "(.*)"');
} else {
  console.log('[patch] Already correct, no change needed');
}
