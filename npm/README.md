# shinjuku-shielded

The Shinjuku Shielded wallet: a self-custody wallet that pays x402 URLs
privately from a shielded USDC balance on Solana. Its `mcp` command runs a
local MCP server (stdio) for your agent. Your keys never leave your machine.

## Set up

```sh
npx -y shinjuku-shielded setup
```

Setup makes the wallet on this machine, a private passphrase file, and the
checked proof tools (about 191 MB), and writes `config.json`. It also writes
a recovery file: copy it to two offline places, then delete it from this
machine. `--add-to claude-code` (or `claude-desktop`, `cursor`) also adds the
server to that host's config.

## Add it to your agent host

Claude Code:

```sh
claude mcp add --scope user shinjuku-shielded -- npx -y shinjuku-shielded mcp
```

Claude Desktop (`claude_desktop_config.json`) or Cursor (`~/.cursor/mcp.json`):

```json
{ "mcpServers": { "shinjuku-shielded": { "command": "npx", "args": ["-y", "shinjuku-shielded", "mcp"] } } }
```

On native Windows, if the host cannot find `npx`, use `"command": "cmd"` and
put `"/c", "npx"` at the start of `args`. To pin the version, write
`shinjuku-shielded@0.3.53`.

## Add funds

Ask your agent "Add 0.50 USDC to my shielded balance". It calls
`wallet_add_funds` and gives a one-time address. Send USDC on Solana to it
from any wallet or exchange. Cents work (from 0.01 USDC), and you need no
SOL. The USDC becomes private by itself while the MCP server runs.

## Pay

Spending limits are optional and off by default: only the balance bounds a
payment. To set them, give setup `--max-payment`, `--max-session`, or
`--max-total` (atomic USDC: `50000` = 0.05 USDC).

`x402_discover` finds sellers in public x402 listings, `x402_preview` shows
the price, and `x402_pay` pays.

## Needs

- Node.js 22 or later.
- Linux, or Windows with WSL. macOS is not supported: the provers are Linux
  programs.

The package has no install scripts. `node_modules/.bin` and the global npm
folder must not be writable by other users: the MCP server holds your wallet
keys.

This package holds one wallet release, unchanged. The `shinjukuRelease` and
`shinjukuSha256` fields in `package.json` name that release. Compare the hash
with the Releases table in
[ShinjukuStaition/shinjuku-shielded](https://github.com/ShinjukuStaition/shinjuku-shielded#releases).
From 0.1.1 on, versions are published from GitHub Actions with npm
provenance.

The full guide is
[ShinjukuStaition/shinjuku-mcp](https://github.com/ShinjukuStaition/shinjuku-mcp).

## License

`LICENSE.txt` (Shinjuku Shielded wallet, all rights reserved) and
`THIRD_PARTY_NOTICES.txt` (the open-source packages inside the file) ship
unchanged from the release. `manifest.json` names the source commit and every
bundled package.
