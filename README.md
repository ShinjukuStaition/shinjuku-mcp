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
repository holds the setup guide only. The wallet file, its SHA-256, and its
release history are in
[ShinjukuStaition/shinjuku-shielded](https://github.com/ShinjukuStaition/shinjuku-shielded).

## Tools

### SHIELD

| Tool | What it does |
|---|---|
| `wallet_shield` | Moves USDC from the wallet's own Solana key into your shielded balance. Off until you start the server with `--allow-shield` and `--max-shield`. Funding takes minutes: the first call starts it and returns a stage. Call again with the same `request_id` to see the stage. It never starts a second deposit. |

### PAY

| Tool | What it does |
|---|---|
| `x402_preview` | One unpaid request. Returns the seller's price, the scheme, and whether your caps allow it. Pays nothing. |
| `x402_pay` | Pays the URL (if it asks for payment) and returns the answer. A URL that does not answer 402 is fetched once and nothing is paid. Alias: `fetch_paid`. |

### UNSHIELD

| Tool | What it does |
|---|---|
| `wallet_unshield` | Sends shielded USDC to a public Solana address. Off until you start the server with `--unshield-to` and `--max-unshield`. The address must be one that you named with `--unshield-to`, so a prompt injection cannot send your money to its own address. The same `request_id` never unshields twice. |

### ACCOUNT

| Tool | What it does |
|---|---|
| `wallet_balance` | SHIELDED (what your agent can pay with) and UNSHIELDED (plain USDC on the wallet's own Solana key), each on its own line, plus pockets, unfinished payments, and what this session may still pay. UNSHIELDED is one network read; if it fails, that line is empty and says why. |
| `wallet_receipts` | Your most recent paid receipts: host (never the full URL), amount, transaction, time. |

Also: `wallet_cancel` closes one unfinished payment, so its reserved balance
comes back.

`wallet_shield` and `wallet_unshield` always appear in the tool list. When
you did not turn one on, it answers `"error": "mcp_tool_disabled"` and tells
the agent to ask you.

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
| Needs | Nothing extra. | Tor on `127.0.0.1:9050`. |

## 1. Get the wallet

Node.js 22 or later. Download the current release and check its SHA-256
before you run it. The current file and hash are in the
[Releases table](https://github.com/ShinjukuStaition/shinjuku-shielded#releases)
and in section 7b of https://shinjukustaition.com/skill.md.

```sh
curl -fsSLO https://shinjukustaition.com/wallet/<release>/shinjuku-wallet.mjs
echo "<sha256>  shinjuku-wallet.mjs" | sha256sum -c -
node shinjuku-wallet.mjs help mcp
```

## 2. Make and fund the wallet

Follow https://shinjukustaition.com/skill.md section 7b: `init`, the proof
tools (Linux, or WSL on Windows; about 144 MB, every file hash-checked), and
funding your shielded balance. `node shinjuku-wallet.mjs help init` and
`help add-funds` say the same on your machine. Your agent can also fund the
shielded balance itself with `wallet_shield`.

## 3. Add it to your agent

The session flags for the production pool:

```
--pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8
--program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1
--memo-service https://pay.shinjukustaition.com
--proof-tools /abs/path/shinjuku-proof-tools/proof-tools.json
--passphrase-file /abs/path/passphrase.txt
```

Caps are in atomic USDC units: `50000` = 0.05 USDC. The shield and unshield
flags are optional. Leave them out and both tools stay off.

### Claude Code

```sh
claude mcp add shinjuku-pay -- node /abs/path/shinjuku-wallet.mjs mcp \
  --max-payment 50000 --max-session 200000 --tor \
  --allow-shield --max-shield 5000000 \
  --unshield-to <your-solana-address> --max-unshield 5000000 \
  --pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8 \
  --program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1 \
  --memo-service https://pay.shinjukustaition.com \
  --proof-tools /abs/path/shinjuku-proof-tools/proof-tools.json \
  --passphrase-file /abs/path/passphrase.txt
```

### Claude Desktop, Cursor, and other JSON-config hosts

Use absolute paths: a host starts the server from its own folder. On Windows,
write `C:/Users/you/...`.

```json
{
  "mcpServers": {
    "shinjuku-pay": {
      "command": "node",
      "args": [
        "/home/you/shinjuku/shinjuku-wallet.mjs", "mcp",
        "--max-payment", "50000", "--max-session", "200000", "--tor",
        "--allow-shield", "--max-shield", "5000000",
        "--unshield-to", "<your-solana-address>", "--max-unshield", "5000000",
        "--pool", "AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8",
        "--program", "8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1",
        "--memo-service", "https://pay.shinjukustaition.com",
        "--proof-tools", "/home/you/shinjuku/shinjuku-proof-tools/proof-tools.json",
        "--passphrase-file", "/home/you/shinjuku/passphrase.txt"
      ],
      "env": { "SHIELDED_WALLET_HOME": "/home/you/.shielded-wallet" }
    }
  }
}
```

Claude Desktop: `claude_desktop_config.json`. Cursor: `~/.cursor/mcp.json`.

## Caps and flags

| Flag | |
|---|---|
| `--max-payment <atomic>` | Required. The most one payment may cost. Without it the server does not start (`mcp_cap_required`). |
| `--max-session <atomic>` | Required. The most this server process may pay in total. Must be at least `--max-payment`. |
| `--max-per-host-day <atomic>` | Optional. The most one seller host may receive in 24 hours. |
| `--allow-host <host>` | Optional, repeatable. Pay only these seller hosts. |
| `--allow-shield` | Optional. Turns on `wallet_shield`. Needs `--max-shield`. |
| `--max-shield <atomic>` | Required with `--allow-shield`. The most one shield call may move, and the most this process may shield in total. |
| `--unshield-to <address>` | Optional, repeatable. Turns on `wallet_unshield`, and only these addresses can receive. Needs `--max-unshield`. |
| `--max-unshield <atomic>` | Required with `--unshield-to`. The most one unshield call may move, and the most this process may unshield in total. |
| `--tor` | Optional. Every request goes through Tor; our facilitator is reached over its onion service. Needs Tor on `127.0.0.1:9050`. See Privacy modes. |
| `--rpc-file <file>` | Optional. Your own Solana RPC URL. Without it, reads go to our relay, which sees which accounts the wallet reads. |

The passphrase comes from `--passphrase-file` or `SHIELDED_WALLET_PASSPHRASE`
at start, never from a tool call. A refusal is a normal answer
(`{"ok": false, "error", "detail", "next"}`); the agent does what `next`
says. A cap refusal tells the agent to ask you: only you set the caps.

## What others can see

- The seller sees your request, the price, the time, and your IP unless you
  use `--tor`.
- Your agent host and its model provider see every URL, body, price, paid
  answer, amount, and unshield address the agent handles. A local model
  removes that observer.
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

Live on Solana mainnet with wallet release `b7d6f394` (2026-10-08). Proven
with real money through this MCP server, against our production facilitator:

| Tool | Transaction |
|---|---|
| `wallet_shield` (1 USDC in) | [`hWzDiR1R…izn`](https://solscan.io/tx/hWzDiR1RnC1gFXMMrCxRBCZ4R5dgMreWGX7vyQCTUTWkKaKnYvxmro6PQuE9KMYVbrq3NkNu9YaJzj7XaqrDizn) |
| `wallet_unshield` (0.5 USDC out) | self-pay [`5evVHz8X…r9uv`](https://solscan.io/tx/5evVHz8XvMdSYF76BQ1xv3TazwS9P38FEXp81gipNMMSqn61Rj7EUc1DdgpYz591wQbBZMWcpNVznixXPsfZr9uv) · exit [`4yY2YXLS…pgF2i`](https://solscan.io/tx/4yY2YXLSj1EyUWDb7X9985KmyeNGQieF8skg3uN3sv3Pds3zSb42J5owDWMUTshui6XACkP4zwGxUmXXTVapgF2i) |
| `x402_pay` (pocket `exact`) | [`kX2zbbuR…8wW`](https://solscan.io/tx/kX2zbbuRbskBQ2EnazyDBu7oZ7BtySVT7zDmtBn7ZivMm3guhLWrJGiPFFLzTEyxwTKUkeSAJjTJLSWLHYP48wW) |

Neither unshield transaction contains the wallet that shielded; our
facilitator paid every network fee of the unshield.

Full guide: https://shinjukustaition.com/skill.md ·
Onion: http://2kfhlfuyuwvhmibjrpxqsg4nrbcxasjgjq7kmnfzgfwzptkhhznz3dad.onion/skill.md ·
X: [@Shin_StAItion](https://x.com/Shin_StAItion)
