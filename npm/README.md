# Shinjuku Shield

The Shinjuku Shield wallet: a self-custody wallet that pays x402 URLs
privately from a shielded USDC balance on Solana. It also pays for AI
answers privately, in a terminal chat or for your agent app. Its `mcp`
command runs a local MCP server (stdio) for your agent. Your keys never
leave your machine.

This is version {{VERSION}}. The npm packages `shinjuku-shield` and
`shinjuku-shielded` hold the same files; `shinjuku` is the short command.

## Set up

```sh
npx -y --no-audit --no-fund shinjuku-shield@{{VERSION}} setup
```

Setup makes the wallet on this machine, a private passphrase file, and the
checked proof tools (about 191 MB), and writes `config.json`. It also writes
a recovery file: copy it to two offline places, then delete it from this
machine. `--add-to claude-code` (or `claude-desktop`, `cursor`) also adds the
server to that host's config.

## The `shinjuku` command

```sh
npm install -g shinjuku@{{VERSION}}
shinjuku help
```

Every wallet command works after `shinjuku`, for example `shinjuku balance`,
`shinjuku chat` or `shinjuku infer start`.

## Add it to your agent host

Claude Code:

```sh
claude mcp add --scope user shinjuku-shielded -- npx -y --no-audit --no-fund shinjuku-shield@{{VERSION}} mcp
```

Claude Desktop (`claude_desktop_config.json`) or Cursor (`~/.cursor/mcp.json`):

```json
{ "mcpServers": { "shinjuku-shielded": { "command": "npx", "args": ["-y", "--no-audit", "--no-fund", "shinjuku-shield@{{VERSION}}", "mcp"] } } }
```

On native Windows, if the host cannot find `npx`, use `"command": "cmd"` and
put `"/c", "npx"` at the start of `args`. The server keeps the name
`shinjuku-shielded` in host configs.

## Add funds

Ask your agent "Add 0.50 USDC to my shielded balance". It calls
`wallet_add_funds` and gives a one-time address. Send USDC on Solana to it
from any wallet or exchange. Cents work (from 0.01 USDC), and you need no
SOL. The USDC becomes private by itself.

## Pay

Spending limits are optional and off by default: only the balance bounds a
payment. To set them, give setup `--max-payment`, `--max-session`, or
`--max-cumulative`, in USDC (`0.05` = 5 cents).

`x402_discover` finds sellers in public x402 listings, `x402_preview` shows
the price, and `x402_pay` pays.

## Private AI

Each answer is paid from your shielded balance, through Tor: the AI
provider sees your words, not your IP address, and the chain does not show
which wallet paid. The wallet keeps no copy of a conversation.

- `shinjuku chat`: a chat in this terminal. Each answer has a cap (0.05 USDC
  by default) and each chat has a cap (1 USDC by default).
- `shinjuku infer start`: a local AI address for an agent app that speaks
  the OpenAI API. It prints the `base_url` (`http://127.0.0.1:11402/v1`) and
  an api key. It keeps running in the background after the terminal closes;
  `shinjuku infer status` shows it, and `shinjuku infer stop` stops it. Your
  agent can also start it with the MCP tool `inference_server`. It serves
  the OpenAI Chat Completions API (`/v1/chat/completions`, streaming too)
  and `/v1/models`. Apps that use the OpenAI Responses API
  (`/v1/responses`) do not work with it yet.
- `inference_chat` (MCP): one answer for your agent.

## Needs

- Node.js 22.21 or later, or Node.js 24 or later (a `--tor` run needs `NODE_USE_ENV_PROXY`, which Node.js 23 does not have).
- Linux, or Windows with WSL. macOS is not supported: the provers are Linux
  programs.
- Tor, for private AI (and for `--tor`).

The package has no install scripts. `node_modules/.bin` and the global npm
folder must not be writable by other users: the MCP server holds your wallet
keys.

This package holds one wallet release, unchanged. The `shinjukuRelease` and
`shinjukuSha256` fields in `package.json` name that release. Compare the hash
with the Releases table in
[ShinjukuStaition/shinjuku-shielded](https://github.com/ShinjukuStaition/shinjuku-shielded#releases).
Versions are published from GitHub Actions with npm provenance.

The full guide is
[ShinjukuStaition/shinjuku-mcp](https://github.com/ShinjukuStaition/shinjuku-mcp).

## License

`LICENSE.txt` (the Shinjuku Shielded wallet license, all rights reserved) and
`THIRD_PARTY_NOTICES.txt` (the open-source packages inside the file) ship
unchanged from the release. `manifest.json` names the source commit and every
bundled package.
