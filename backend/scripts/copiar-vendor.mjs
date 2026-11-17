import { copyFile, mkdir } from 'node:fs/promises';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';

const require = createRequire(import.meta.url);
const origem = require.resolve('qrcode-generator');
const pasta = new URL('../../frontend/src/assets/js/vendor/', import.meta.url);
await mkdir(pasta, { recursive: true });
await copyFile(origem, new URL('qrcode.js', pasta));
console.log(`Biblioteca QR instalada em ${fileURLToPath(pasta)}qrcode.js`);
