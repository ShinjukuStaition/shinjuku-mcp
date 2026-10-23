#!/usr/bin/env node
// `shinjuku` runs the Shinjuku Shield wallet (the one package in package.json dependencies: shinjuku-shield, or
// shinjuku-shielded before 0.3.81) at the exact version named there: the same commands, input, output and exit code as
// the wallet's own shinjuku-wallet command.
import { realpathSync } from "node:fs";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

const require = createRequire(import.meta.url);
const [walletPackage] = Object.keys(require("./package.json").dependencies);
const wallet = realpathSync(require.resolve(`${walletPackage}/shinjuku-wallet.mjs`));
// The wallet runs its command when it is the script node started (argv[1]), and its background steps start that same file.
process.argv[1] = wallet;
await import(pathToFileURL(wallet).href);
