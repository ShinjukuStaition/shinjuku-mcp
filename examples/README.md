# Examples

Configs and walkthroughs for the Shinjuku Shielded MCP server: the private
x402 facilitator on Solana, inside your agent.

| File | What it is |
|---|---|
| [claude-code.md](claude-code.md) | The `claude mcp add` command, the first start, Tor, the caps, and how to check it works. |
| [claude-desktop.json](claude-desktop.json) | A complete `claude_desktop_config.json`. |
| [cursor.json](cursor.json) | A complete `~/.cursor/mcp.json` (or `.cursor/mcp.json` in a project). |
| [hermes.md](hermes.md) | The Hermes Agent `config.yaml` entry (stdio). |
| [prompts.md](prompts.md) | 11 plain requests, the tool that each one calls, and the shape of the answer. |

All examples run `npx -y shinjuku-shielded mcp`: the newest npm version
(0.3.4, wallet release `14dd9efa`). Write `shinjuku-shielded@0.3.4` to pin
it. The commands and flags come from `help mcp` and `help setup` of that
release.

## Where it runs

- Linux: ready.
- Windows: the wallet runs the provers through WSL. Setup checks that
  `wsl.exe` runs; if it does not, run `wsl --install -d Ubuntu`. If the host
  cannot find `npx`, use `"command": "cmd"` and put `"/c", "npx"` at the
  start of `args`.
- macOS: not supported. Setup says so and creates nothing.

## First 10 minutes

Each step shows what you do, or what you say to the agent and the tool that
the agent calls. Amounts are in atomic USDC: 1000000 = 1 USDC.

### 1. Install Node.js 22 or later

```sh
node --version
```

The output must be `v22` or higher.

### 2. Add the server to your agent

Use one of [claude-code.md](claude-code.md), [claude-desktop.json](claude-desktop.json),
[cursor.json](cursor.json), or [hermes.md](hermes.md). Restart the agent
host after you change its config.

### 3. Set it up

| You say | The agent calls |
|---|---|
| "what is my balance" | `shinjuku_setup`. Your client asks you to confirm that it may create a Shinjuku Shielded wallet on this machine, with the caps. |

Accept. The setup runs (about 25 s in our test, with the proof-tool
download of about 150 MB) and the same server switches to the wallet
tools. If your client cannot show the question, run `npx -y shinjuku-shielded setup` in a
terminal, then restart the agent host.

Setup writes to `~/.carbon-shielded-wallet`:

- The wallet, a random passphrase file (readable by you alone, never
  printed), the proof tools (every file checked), and `config.json`.
- A recovery file with the seed and the Solana secret key. Copy it to two
  offline places, then delete it from this machine.
- The default caps: 0.05 USDC per payment, 1 USDC per session, and 20 USDC
  for the life of the wallet. To pick your own, run the setup in a terminal
  with `--max-payment`, `--max-session`, and `--max-total`
  (`npx -y shinjuku-shielded help setup`).

### 4. Get the wallet address

| You say | The agent calls |
|---|---|
| "what is my wallet address?" | `wallet_balance`. The answer has `ownAddress`: the wallet's own public Solana address. |

### 5. Fund the wallet

Send USDC (Solana SPL) to that address from your own wallet or an
exchange. You do not need SOL: our facilitator's relayer pays the network
fee of the shield, and you pay the shield cost.

| You say | The agent calls |
|---|---|
| "shield 1 USDC" | `wallet_shield {amount_atomic: "1000000", request_id: "shield-1"}` |

The shield takes a few minutes. The first call starts it and answers a
`stage`. The agent calls `wallet_shield` again with the same `request_id` to
read the stage. The same `request_id` never starts a second deposit. When
the deposit lands, the wallet reads it from the chain and writes an
encrypted backup to `$SHIELDED_WALLET_HOME/auto-backups/<pool>/` by itself.
Use a whole number of USDC.

A shield is a public step. The chain shows USDC leave the wallet's own
address, the amount, and the time. Payments from the shielded balance after
that do not show this wallet. For a funding path that does not start from
your own address, see `npx -y shinjuku-shielded help add-funds`.

### 6. Pay a URL

| You say | The agent calls |
|---|---|
| "find a seller of weather data" | `x402_discover`. It searches public x402 listings on your machine and pays nothing. The first call takes about 15 s. |
| "what does https://seller.example/report cost?" | `x402_preview {url}`. It pays nothing. It shows the seller's price and whether your caps allow it. |
| "pay it" | `x402_pay {url}`. It pays the seller's price from your shielded balance and returns the answer. |

A paid answer has `paid: true` and a `transaction`. The agent must not say
that a payment happened without a `transaction`. A URL that does not answer
HTTP 402 is fetched once, and nothing is paid. A price above your caps is
refused before anything is signed. For a standard `exact` seller, `x402_pay`
fills a 1 USDC pocket from your shielded balance when it needs one. An image
answer comes back as an image, and the file is saved.

### 7. Send USDC to an address, with your confirmation

| You say | The agent calls |
|---|---|
| "send 0.5 USDC to <address>" | `wallet_unshield {amount_atomic: "500000", to: "<address>", request_id: "send-1"}` |

If `<address>` is not in `--unshield-to`, your client shows a question:
"Send 0.5 USDC from your shielded balance to <address>?". Only an accept
sends. A decline, or no answer in 5 minutes, sends nothing. The model
cannot answer this question; your client app asks you.

- The receiving address must already have a USDC token account.
- The wallet's own address is refused: it made the deposits, so a send there
  would link them.
- Our facilitator pays every network fee. The send takes minutes (one
  5-minute pool epoch is normal).
- An unshield is a public step. The chain shows the amount, the receiving
  address, and the time. The pool hides which deposit paid it.

### 8. Check the balance

| You say | The agent calls |
|---|---|
| "what is my balance" | `wallet_balance` |

The answer shows SHIELDED (`shieldedAtomic`, what the agent can pay and
send with) and UNSHIELDED (`unshieldedAtomic`, plain USDC on the wallet's
own address), the pockets, unfinished payments, and `session` (what this
server process may still pay).

More requests: [prompts.md](prompts.md).

## What others can see

- The seller sees your request, the price, and the time. It sees your IP
  unless you use `--tor`.
- Your agent host and its model provider see every URL, price, paid answer,
  amount, and send address that the agent handles. A local model removes
  that observer.
- Our facilitator processes your payments. It keeps no access logs.
- On chain, a shielded payment does not show who paid. Privacy needs a
  crowd: with few users, timing can still link payments.
