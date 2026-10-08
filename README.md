# Shinjuku MCP

Give your AI agent a private wallet. It pays x402 URLs from a shielded USDC
balance on Solana, under spend caps that only you set.

- **Self-custody.** The MCP server runs on your machine. Your keys never
  leave it. We never run it, and we never hold your money.
- **Private payments.** Your agent pays from a shielded balance: on chain,
  the payment does not show who paid. Add `--tor` and no server sees your IP.
- **Caps that only you set.** `--max-payment` and `--max-session` are
  required at launch. A tool call can only lower them, never raise them.
- **Look before you pay.** `x402_preview` shows the price and whether your
  caps allow it. It pays nothing.
- **Never pays twice.** A retry with the same `request_id` resumes the same
  payment.
- **No RPC, no account, no API key.** Reads go through our relay by default;
  your own RPC always wins if you give one.

The server is the `mcp` command of `shinjuku-wallet`, one file. This
repository holds the setup guide only. The wallet file, its SHA-256, and its
release history are in
[ShinjukuStaition/shinjuku-shielded](https://github.com/ShinjukuStaition/shinjuku-shielded).

## Tools

| Tool | What it does |
|---|---|
| `x402_preview` | One unpaid request. Returns the seller's price, the scheme, and whether your caps allow it. Pays nothing. |
| `x402_pay` | Pays the URL (if it asks for payment) and returns the answer. A URL that does not answer 402 is fetched once and nothing is paid. Alias: `fetch_paid`. |
| `wallet_balance` | Your balance from local files (no network call): spendable shielded amount, pockets, unfinished payments, and what this session may still pay. |
| `wallet_receipts` | Your most recent paid receipts: host (never the full URL), amount, transaction, time. |
| `wallet_cancel` | Closes one unfinished payment so its reserved balance comes back. A sent payment closes only when the pool's history shows it never landed. |

What it pays: x402 scheme `shielded-exact` from your shielded balance, and
standard Solana `exact` from a ready pocket. A ready pocket pays any Solana
x402 `exact` seller, whichever facilitator settles it. For sellers that
offer only `confidential` (hidden amounts), use `shinjuku-wallet laneb pay-url`.

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
`help add-funds` say the same on your machine.

## 3. Add it to your agent

The session flags for the production pool:

```
--pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8
--program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1
--memo-service https://pay.shinjukustaition.com
--proof-tools /abs/path/shinjuku-proof-tools/proof-tools.json
--passphrase-file /abs/path/passphrase.txt
```

Caps are in atomic USDC units: `50000` = 0.05 USDC.

### Claude Code

```sh
claude mcp add shinjuku-pay -- node /abs/path/shinjuku-wallet.mjs mcp \
  --max-payment 50000 --max-session 200000 --tor \
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
| `--tor` | Optional. Every request goes through Tor; our facilitator is reached over its onion service. Needs Tor on `127.0.0.1:9050`. |
| `--rpc-file <file>` | Optional. Your own Solana RPC URL. Without it, reads go to our relay, which sees which accounts the wallet reads. |

The passphrase comes from `--passphrase-file` or `SHIELDED_WALLET_PASSPHRASE`
at start, never from a tool call. A refusal is a normal answer
(`{"ok": false, "error", "detail", "next"}`); the agent does what `next`
says. A cap refusal tells the agent to ask you: only you set the caps.

## What others can see

- The seller sees your request, the price, the time, and your IP unless you
  use `--tor`.
- Your agent host and its model provider see every URL, body, price, and
  paid answer the agent handles. A local model removes that observer.
- Our facilitator processes your payment. It keeps no access logs.
- On chain, a `shielded-exact` payment does not show who paid. A pocket
  `exact` payment is a normal USDC transfer from the pocket address.
- Privacy needs a crowd. With few users, timing can still link payments.

## Status

The `mcp` command ships in the production wallet since 2026-10-07. Paid
calls over MCP are new and not yet proven with money on production; the
evidence goes here and to `/skill.md` when they are.

Full guide: https://shinjukustaition.com/skill.md ·
Onion: http://2kfhlfuyuwvhmibjrpxqsg4nrbcxasjgjq7kmnfzgfwzptkhhznz3dad.onion/skill.md ·
X: [@Shin_StAItion](https://x.com/Shin_StAItion)
