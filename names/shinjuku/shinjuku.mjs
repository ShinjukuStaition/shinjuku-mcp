#!/usr/bin/env node
// `shinjuku` runs the Shinjuku Shield wallet (npm shinjuku-shielded) at the exact version that package.json
// names in dependencies: the same commands, input, output and exit code as the wallet's own shinjuku-wallet command.
import { realpathSync } from "node:fs";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

const require = createRequire(import.meta.url);
const wallet = realpathSync(require.resolve("shinjuku-shielded/shinjuku-wallet.mjs"));
// The wallet runs its command when it is the script node started (argv[1]), and its background steps start that same file.
process.argv[1] = wallet;
await import(pathToFileURL(wallet).href);
