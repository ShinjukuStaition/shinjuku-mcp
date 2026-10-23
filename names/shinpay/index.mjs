#!/usr/bin/env node
// shinpay: a name of Shinjuku Shield (private x402 payments). It installs nothing: it prints how to install the wallet.
const PIN = "0.3.80";
process.stdout.write([
  "Shinjuku Shield: a self-custody wallet that pays x402 URLs privately from a shielded USDC balance on Solana.",
  "",
  "This package (shinpay) only points to the wallet. Install the wallet at its stable version:",
  `  npm install -g shinjuku-shielded@${PIN}`,
  "  shinjuku-shielded setup",
  "",
  "Or run setup once without installing:",
  `  npx -y --no-audit --no-fund shinjuku-shielded@${PIN} setup`,
  "",
  "Docs and host configs: https://github.com/ShinjukuStaition/shinjuku-mcp",
  "",
].join("\n"));
