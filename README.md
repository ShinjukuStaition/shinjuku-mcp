<p align="center"><img src="assets/banner.png" alt="Shinjuku Shielded MCP: the private x402 facilitator, inside your agent" width="100%"></p>

<p align="center">
<img alt="Solana mainnet" src="https://img.shields.io/badge/Solana-mainnet-D22B23?style=flat-square&labelColor=0C0707">
<img alt="x402 facilitator" src="https://img.shields.io/badge/x402-private%20facilitator-D22B23?style=flat-square&labelColor=0C0707">
<img alt="MCP" src="https://img.shields.io/badge/MCP-stdio-DEB868?style=flat-square&labelColor=0C0707">
<img alt="Self-custody" src="https://img.shields.io/badge/keys-self--custody-DEB868?style=flat-square&labelColor=0C0707">
<img alt="Tor" src="https://img.shields.io/badge/Tor-built%20in-ECE6DA?style=flat-square&labelColor=0C0707">
</p>

# Shinjuku Shielded MCP

The private x402 facilitator, inside your agent.

Shinjuku Shielded settles x402 payments from a shielded USDC balance on
Solana: on chain, a shielded payment does not show who paid. This MCP server
is how your agent uses it. It runs on your machine, under caps that only you
set.

- **Self-custody.** The server runs on your machine. Your keys never leave
  it. We never run it, and we never hold your money.
- **Shielded payments.** Your agent pays from a shielded balance. Add `--tor`
  and no server sees your IP.
- **Caps that only you set.** `--max-payment` and `--max-session` are
  required at launch. A tool call can only lower them, never raise them.
- **Look before you pay.** `x402_preview` shows the price and whether your
  caps allow it. It pays nothing.
- **Never twice.** A retry with the same `request_id` resumes the same
  payment, deposit, or unshield. It never starts a second one.
- **No RPC, no account, no API key.** Reads go through our relay by default.
  Your own RPC always wins if you give one.

Every Shinjuku Shielded service joins this MCP as it ships.

The server is the `mcp` command of `shinjuku-wallet`, one file. This
repository holds the setup guide and [examples](examples/). The wallet file, its SHA-256, and its
release history are in
[ShinjukuStaition/shinjuku-shielded](https://github.com/ShinjukuStaition/shinjuku-shielded).

## Talk to it in plain words

Ask your agent the way you would ask a person:

| You say | Your agent calls |
|---|---|
| "what is my balance" | `wallet_balance` |
| "shield 5 USDC" | `wallet_shield` |
| "pay this URL" | `x402_preview`, then `x402_pay` |
| "send 2 USDC privately to <address>" | `wallet_unshield` |

Each answer tells the agent the exact next call. The wallet reads the chain
and writes an encrypted backup by itself, so you never run a command for
upkeep.

## Tools

### SHIELD

| Tool | What it does |
|---|---|
| `wallet_shield` | Moves USDC from the wallet's own Solana key into your shielded balance. It is on with `--proof-tools`. `--no-shield` turns it off. Funding takes minutes: the first call starts it and returns a stage. Call again with the same `request_id` to see the stage. It never starts a second deposit. When the deposit lands, the wallet reads it from the chain and writes an encrypted backup. The wallet's own key needs the USDC and about 0.01 SOL. |

### PAY

| Tool | What it does |
|---|---|
| `x402_preview` | One unpaid request. Returns the seller's price, the scheme, and whether your caps allow it. Pays nothing. |
| `x402_pay` | Pays the URL (if it asks for payment) and returns the answer. A URL that does not answer 402 is fetched once and nothing is paid. Alias: `fetch_paid`. |

### UNSHIELD

| Tool | What it does |
|---|---|
| `wallet_unshield` | Sends shielded USDC to a public Solana address. It is on with `--exit-proof-tools` and `--profile`. Our facilitator pays every network fee. The same `request_id` never unshields twice. An address that you named with `--unshield-to` is sent at once. Any other address is sent only after you confirm it in your MCP client: "Send X USDC from your shielded balance to <address>?". A decline, or no answer in 5 minutes, sends nothing. A client that cannot ask is refused, so a prompt injection cannot pick an address by itself. The wallet's own key is refused: it made the deposits, so an exit there would link them. |

### ACCOUNT

| Tool | What it does |
|---|---|
| `wallet_balance` | SHIELDED (what your agent can pay with) and UNSHIELDED (plain USDC on the wallet's own Solana key), each on its own line, plus pockets, unfinished payments, and what this session may still pay. A stale balance is read from the chain first. UNSHIELDED is one network read; if it fails, that line is empty and says why. |
| `wallet_receipts` | Your most recent paid receipts: host (never the full URL), amount, transaction, time. |

Also: `wallet_cancel` closes one unfinished payment, so its reserved balance
comes back.

`wallet_shield` and `wallet_unshield` always appear in the tool list. When
one is off, it answers `"error": "mcp_tool_disabled"` and tells the agent
what to ask you.

What it pays: x402 scheme `shielded-exact` from your shielded balance, and
standard Solana `exact` from a ready pocket. A ready pocket pays any Solana
x402 `exact` seller, whichever facilitator settles it. For sellers that
offer only `confidential` (hidden amounts), use `shinjuku-wallet laneb pay-url`.

## Privacy modes

| | Default | `--tor` |
|---|---|---|
| On chain | A shielded payment does not show who paid. | The same. |
| Your IP | Payments go to `pay.shinjukustaition.com`, with no CDN in the path. Our server sees your IP. It keeps no access logs. | Hidden from everyone, us included. |
| The seller | Sees your IP. | Does not see your IP. |
| Speed | Faster. | About 1-2 s slower per request. |
| Needs | Nothing extra. | Tor with `HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr` in `torrc`. |

## Setup

You need Node.js 22 or later. The current wallet release is `1a336885`.

### Fastest install (npm)

The npm package `shinjuku-shielded@0.1.1` is wallet release `1a336885`. It
has two commands: `shinjuku-shielded` and `shinjuku-wallet`. `npx` gets it
for you:

```sh
npx -y shinjuku-shielded help mcp
```

### Or download the file and check it

Download the release file and check its SHA-256 before you run it. The
current file and hash are also in the
[Releases table](https://github.com/ShinjukuStaition/shinjuku-shielded#releases)
and in section 7b of https://shinjukustaition.com/skill.md.

```sh
curl -fsSLO https://shinjukustaition.com/wallet/1a336885/shinjuku-wallet.mjs
echo "1a3368854f4bdfe185a2ac398106c9b39a7148225f1a3ec6a6dcead563c7ed53  shinjuku-wallet.mjs" | sha256sum -c -
node shinjuku-wallet.mjs help mcp
```

With the file, replace `npx -y shinjuku-shielded` below with
`node /abs/path/shinjuku-wallet.mjs`.

### Make and fund the wallet

Follow https://shinjukustaition.com/skill.md section 7b: `init`, the proof
tools, and funding your shielded balance. The proof tools are a separate
download with both install options (Linux, or WSL on Windows; about 144 MB,
every file hash-checked). `help init` and `help add-funds` say the same on
your machine. Your agent can also fund the shielded balance itself with
`wallet_shield`.

### Add it to your agent

The session flags for the production pool:

```
--pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8
--program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1
--memo-service https://pay.shinjukustaition.com
--proof-tools /abs/path/shinjuku-proof-tools/proof-tools.json
--exit-proof-tools /abs/path/shinjuku-proof-tools/exit-proof-tools.json
--profile /abs/path/shinjuku-proof-tools/public-profile.json
--passphrase-file /abs/path/passphrase.txt
```

Caps are in atomic USDC units: `50000` = 0.05 USDC. `--proof-tools` turns
`wallet_shield` on. `--exit-proof-tools` and `--profile` (both in the
`shinjuku-proof-tools` folder) turn `wallet_unshield` on.

#### Claude Code

```sh
claude mcp add shinjuku -- npx -y shinjuku-shielded mcp \
  --max-payment 50000 --max-session 200000 --tor \
  --pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8 \
  --program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1 \
  --memo-service https://pay.shinjukustaition.com \
  --proof-tools /abs/path/shinjuku-proof-tools/proof-tools.json \
  --exit-proof-tools /abs/path/shinjuku-proof-tools/exit-proof-tools.json \
  --profile /abs/path/shinjuku-proof-tools/public-profile.json \
  --passphrase-file /abs/path/passphrase.txt
```

#### Claude Desktop, Cursor, and other JSON-config hosts

Use absolute paths: a host starts the server from its own folder. On Windows,
write `C:/Users/you/...`.

```json
{
  "mcpServers": {
    "shinjuku": {
      "command": "npx",
      "args": [
        "-y", "shinjuku-shielded", "mcp",
        "--max-payment", "50000", "--max-session", "200000", "--tor",
        "--pool", "AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8",
        "--program", "8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1",
        "--memo-service", "https://pay.shinjukustaition.com",
        "--proof-tools", "/home/you/shinjuku/shinjuku-proof-tools/proof-tools.json",
        "--exit-proof-tools", "/home/you/shinjuku/shinjuku-proof-tools/exit-proof-tools.json",
        "--profile", "/home/you/shinjuku/shinjuku-proof-tools/public-profile.json",
        "--passphrase-file", "/home/you/shinjuku/passphrase.txt"
      ],
      "env": { "SHIELDED_WALLET_HOME": "/home/you/.shielded-wallet" }
    }
  }
}
```

Claude Desktop: `claude_desktop_config.json`. Cursor: `~/.cursor/mcp.json`.

A send to a new address needs a host that supports MCP elicitation (it shows
you the confirmation). With a host that does not, name each address with
`--unshield-to`.

## Examples

[examples/](examples/) has complete configs and a walkthrough:

- [Claude Code](examples/claude-code.md): the `claude mcp add` command with
  and without Tor, each flag explained, and how to check it works.
- [Claude Desktop](examples/claude-desktop.json) and
  [Cursor](examples/cursor.json): complete JSON configs.
- [Hermes Agent](examples/hermes.md): the `config.yaml` entry.
- [First 10 minutes](examples/README.md#first-10-minutes): install, make the
  wallet, fund it, shield, pay, send, and check the balance.
- [Plain requests](examples/prompts.md): 10 requests, the tool each one
  calls, and the shape of the answer.

## Caps and flags

| Flag | |
|---|---|
| `--max-payment <atomic>` | Required. The most one payment may cost. Without it the server does not start (`mcp_cap_required`). |
| `--max-session <atomic>` | Required. The most this server process may pay in total. Must be at least `--max-payment`. |
| `--max-per-host-day <atomic>` | Optional. The most one seller host may receive in 24 hours. |
| `--allow-host <host>` | Optional, repeatable. Pay only these seller hosts. |
| `--no-shield` | Optional. Turns `wallet_shield` off. It is on with `--proof-tools`. |
| `--max-shield <atomic>` | Optional. The most one shield call may move, and the most this process may shield in total. Without it, no cap beyond the balance. |
| `--allow-shield` | Accepted for older configs. `wallet_shield` is on without it. |
| `--exit-proof-tools <file>`, `--profile <file>` | Optional. Turn `wallet_unshield` on (with `--proof-tools`). |
| `--unshield-to <address>` | Optional, repeatable. These addresses receive with no confirmation. Any other address needs your confirmation in the MCP client. The wallet's own key is refused: the server does not start when you name it here. |
| `--max-unshield <atomic>` | Optional. The most one unshield call may move, and the most this process may unshield in total. Without it, a send you confirm can move the whole shielded balance. |
| `--tor` | Optional. Every request goes through Tor; our facilitator is reached over its onion service. Needs Tor with `HTTPTunnelPort 127.0.0.1:9080` in `torrc`. See Privacy modes. |
| `--rpc-file <file>` | Optional. Your own Solana RPC URL. Without it, reads go to our relay, which sees which accounts the wallet reads. |

The passphrase comes from `--passphrase-file` or `SHIELDED_WALLET_PASSPHRASE`
at start, never from a tool call. A refusal is a normal answer
(`{"ok": false, "error", "detail", "next"}`); the agent does what `next`
says. A cap refusal tells the agent to ask you: only you set the caps.

An unshield is your own money, so it does not count against the payment
budget of the wallet file (`init --max-payment`, `--max-cumulative`).
Payments to sellers still count.

Upkeep is automatic. After a deposit lands, and before a payment or unshield
when the local balance is stale, the server reads the chain itself. After
each shield and unshield, the wallet writes an encrypted backup to
`<SHIELDED_WALLET_HOME>/auto-backups/<pool>/`. It keeps the newest 5
complete, verified backups. They are on the same disk as the wallet: copy
one to another place.

## What others can see

- The seller sees your request, the price, the time, and your IP unless you
  use `--tor`.
- Your agent host and its model provider see every URL, body, price, paid
  answer, amount, and unshield address the agent handles. A local model
  removes that observer.
- Your MCP client app (Claude Code, Claude Desktop, Cursor, ...) answers the
  confirmation of a send, not the model. So a prompt-injected agent cannot
  approve a send. But the wallet trusts the client app to show the dialog to
  you: a malicious or modified client app could answer "accept" by itself.
  For a strict setup, name your addresses with `--unshield-to` and use a
  client without elicitation. Then any other address is refused.
- Our facilitator processes your payment. It keeps no access logs.
- On chain, a `shielded-exact` payment does not show who paid. A pocket
  `exact` payment is a normal USDC transfer from the pocket address.
- `wallet_shield` is a public step: the chain shows USDC leave the wallet's
  own key, the amount, and the time.
- `wallet_unshield` is a public step: the chain shows the amount, the
  address that receives it, and the time.
- The UNSHIELDED line of `wallet_balance` reads the wallet's own key. The RPC
  (our relay by default) sees which key it reads.
- Privacy needs a crowd. With few users, timing can still link payments.

## Status

Listed in the official [MCP Registry](https://registry.modelcontextprotocol.io/v0/servers?search=io.github.ShinjukuStaition/shinjuku-mcp)
as `io.github.ShinjukuStaition/shinjuku-mcp`. npm: [`shinjuku-shielded`](https://www.npmjs.com/package/shinjuku-shielded),
published from this repository's workflow with npm provenance (from 0.1.1).

Live on Solana mainnet with wallet release `1a336885` (2026-10-08). Proven
with real money through this MCP server, against our production facilitator:

| Tool | Transaction |
|---|---|
| `wallet_shield` (1 USDC in) | [`hWzDiR1R…izn`](https://solscan.io/tx/hWzDiR1RnC1gFXMMrCxRBCZ4R5dgMreWGX7vyQCTUTWkKaKnYvxmro6PQuE9KMYVbrq3NkNu9YaJzj7XaqrDizn) |
| `wallet_unshield` (0.5 USDC out) | self-pay [`5evVHz8X…r9uv`](https://solscan.io/tx/5evVHz8XvMdSYF76BQ1xv3TazwS9P38FEXp81gipNMMSqn61Rj7EUc1DdgpYz591wQbBZMWcpNVznixXPsfZr9uv) · exit [`4yY2YXLS…pgF2i`](https://solscan.io/tx/4yY2YXLSj1EyUWDb7X9985KmyeNGQieF8skg3uN3sv3Pds3zSb42J5owDWMUTshui6XACkP4zwGxUmXXTVapgF2i) |
| `wallet_unshield` with your confirmation (0.25 USDC, release `1a336885`) | self-pay [`3jQyPgrA…QEWw`](https://solscan.io/tx/3jQyPgrA5AtFcqzyWHDWRcfNv66sM5qfCStxsByYDqGm7W5uRWkUMHpLoFUFm2jc98Aor7CXSToAChSHD7dWQEWw) · exit [`4yA3qkHU…jCoh`](https://solscan.io/tx/4yA3qkHUto7e7iUGM9q6321avTm8aZQJ6zNMMh18SoAACnvgtvbWpVydry3mCq9iKaSZv92FfH43NJu557zjCoh) |
| `x402_pay` (pocket `exact`) | [`kX2zbbuR…8wW`](https://solscan.io/tx/kX2zbbuRbskBQ2EnazyDBu7oZ7BtySVT7zDmtBn7ZivMm3guhLWrJGiPFFLzTEyxwTKUkeSAJjTJLSWLHYP48wW) |

No unshield transaction contains the wallet that shielded; our facilitator
paid every network fee of each unshield.

Full guide: https://shinjukustaition.com/skill.md ·
Onion: http://2kfhlfuyuwvhmibjrpxqsg4nrbcxasjgjq7kmnfzgfwzptkhhznz3dad.onion/skill.md ·
X: [@Shin_StAItion](https://x.com/Shin_StAItion)
