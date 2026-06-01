// Patches index.mjs to fix Express 5 wildcard route incompatibility
const fs = require('fs');
let content = fs.readFileSync('./index.mjs', 'utf8');
const patched = content.split('app.get("*"').join('app.get("(.*)"');
if (patched !== content) {
  fs.writeFileSync('./index.mjs', patched);
  console.log('[patch] Fixed Express 5 wildcard route: "*" -> "(.*)"');
} else {
  console.log('[patch] Route already correct, no changes needed');
}
