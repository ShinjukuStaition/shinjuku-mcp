# Examples

Configs and walkthroughs for the Shinjuku Shielded MCP server: the private
x402 facilitator on Solana, inside your agent.

| File | What it is |
|---|---|
| [claude-code.md](claude-code.md) | The `claude mcp add` command, with and without Tor. Each flag explained. How to check it works. |
| [claude-desktop.json](claude-desktop.json) | A complete `claude_desktop_config.json`. |
| [cursor.json](cursor.json) | A complete `~/.cursor/mcp.json` (or `.cursor/mcp.json` in a project). |
| [hermes.md](hermes.md) | The Hermes Agent `config.yaml` entry (stdio). |
| [prompts.md](prompts.md) | 10 plain requests, the tool that each one calls, and the shape of the answer. |

All examples use the npm package `shinjuku-shielded@0.1.0`, which is wallet
release `1a336885`. The commands and flags come from `help mcp` of that
release.

## Paths in the JSON configs

The JSON files use placeholder paths under `/home/you/`. Replace each one
with your own absolute path. An MCP host starts the server from its own
folder, so a relative path does not work.

On Windows:

- Write paths with forward slashes: `C:/Users/you/shinjuku/passphrase.txt`.
- Set `SHIELDED_WALLET_HOME` to a folder such as `C:/Users/you/.shielded-wallet`.
- If the host cannot find `npx`, use `"command": "cmd"` and put `"/c", "npx"`
  at the start of `args`.
- The proof tools are Linux programs. Install them in WSL, in a folder on a
  Windows drive (for example `/mnt/c/Users/you/shinjuku/shinjuku-proof-tools`),
  and give the wallet the `C:/` paths. The wallet runs each prover through
  `wsl.exe`.

## First 10 minutes

Each step shows what you do, or what you say to the agent and the tool that
the agent calls. Amounts are in atomic USDC: 1000000 = 1 USDC.

### 1. Install Node.js 22 or later

```sh
node --version
```

The output must be `v22` or higher.

### 2. Get the proof tools (Linux, or WSL on Windows)

The proof tools are 26 files, about 144 MB. Every file is hash-checked.
macOS is not supported: use a Linux machine or a Linux container.

```sh
mkdir -p ~/shinjuku && cd ~/shinjuku
mkdir shinjuku-proof-tools && cd shinjuku-proof-tools
base=https://shinjukustaition.com/proof-tools/82b2d870
curl -fsSO "$base/SHA256SUMS"
echo "82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b  SHA256SUMS" | sha256sum -c -
while read -r sum path; do mkdir -p "$(dirname "$path")"; curl -fsS -o "$path" "$base/$path"; done < SHA256SUMS
sha256sum -c --strict --quiet SHA256SUMS && echo ALL_OK
chmod +x bin/* house/bin/*
```

Go on only when the first check prints `OK` and the last check prints
`ALL_OK`. A match proves that your copy is complete, not who made the files.
The current set is also in section 7b of https://shinjukustaition.com/skill.md.

### 3. Make the wallet

Make a private wallet folder and a passphrase file (8 or more characters).
`read -rs` keeps the passphrase out of your shell history.

```sh
cd ~/shinjuku
mkdir -p ~/.shielded-wallet && chmod 700 ~/.shielded-wallet ~/shinjuku
read -rs -p "Wallet passphrase: " P && (umask 077; printf '%s\n' "$P" > passphrase.txt) && unset P
export SHIELDED_WALLET_HOME=~/.shielded-wallet
SHIELDED_WALLET_PASSPHRASE="$(cat passphrase.txt)" npx -y shinjuku-shielded@0.1.0 init \
  --pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8 \
  --network solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp \
  --asset EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v \
  --max-payment 50000 --max-cumulative 1000000 \
  --backup-out recovery.txt
```

- `init` prints `solanaFeePayer`: the wallet's own public Solana address.
  You fund it in step 5.
- `recovery.txt` holds the seed and the Solana secret key. Copy it to two
  offline places, then delete it from this machine. Keep `solanaFeePayer`
  and `seedFingerprint` beside it.
- `--max-payment` and `--max-cumulative` are the wallet file's own budget
  for payments to sellers: the most one payment may cost, and the most all
  payments may cost together. Without them the defaults are 0.10 and
  0.30 USDC. Pick your own numbers. The MCP caps of step 4 apply as well.
- `npx -y shinjuku-shielded@0.1.0 help init` shows every flag.

### 4. Add the server to your agent

Use one of [claude-code.md](claude-code.md), [claude-desktop.json](claude-desktop.json),
[cursor.json](cursor.json), or [hermes.md](hermes.md). Set
`SHIELDED_WALLET_HOME` to the same folder as in step 3. Restart the agent
host after you change its config.

### 5. Fund the wallet

| You say | The agent calls |
|---|---|
| "what is my wallet address?" | `wallet_balance`. The answer has `ownAddress` (the same as `solanaFeePayer`). |

Send USDC (Solana SPL) and about 0.01 SOL to that address from your own
wallet or an exchange. The SOL pays the Solana fee and rent of the deposit.
Most of it comes back.

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
your own address, see `npx -y shinjuku-shielded@0.1.0 help add-funds`.

### 6. Pay a URL

| You say | The agent calls |
|---|---|
| "what does https://seller.example/report cost?" | `x402_preview {url}`. It pays nothing. It shows the seller's price and whether your caps allow it. |
| "pay it" | `x402_pay {url}`. It pays the seller's price from your shielded balance and returns the answer. |

A paid answer has `paid: true` and a `transaction`. The agent must not say
that a payment happened without a `transaction`. A URL that does not answer
HTTP 402 is fetched once, and nothing is paid. A price above your caps is
refused before anything is signed.

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
