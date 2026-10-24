<p align="center"><img src="assets/banner.png" alt="Shinjuku Shield: private x402 payments on Solana" width="100%"></p>

<p align="center">
<img alt="Solana mainnet" src="https://img.shields.io/badge/Solana-mainnet-D22B23?style=flat-square&labelColor=0C0707">
<img alt="x402 facilitator" src="https://img.shields.io/badge/x402-private%20facilitator-D22B23?style=flat-square&labelColor=0C0707">
<img alt="MCP" src="https://img.shields.io/badge/MCP-stdio-DEB868?style=flat-square&labelColor=0C0707">
<img alt="Self-custody" src="https://img.shields.io/badge/keys-self--custody-DEB868?style=flat-square&labelColor=0C0707">
<img alt="Tor" src="https://img.shields.io/badge/Tor-built%20in-ECE6DA?style=flat-square&labelColor=0C0707">
</p>

# Shinjuku Shield

Shinjuku Shield is a privacy-only x402 payment facilitator on Solana.
An agent pays an x402 endpoint from a balance that it holds itself. The
chain does not show who paid.

- **Privacy-only.** We do not offer a cheaper path that is not private.
- **You keep your keys.** The wallet makes your keys on your machine. We
  never hold them, and we never hold your money.
- **We relay and pay the fees.** Our relayer sends your relayed deposits and
  exits and pays their network fees. Our facilitator pays the network fee of
  each payment that it settles.
- **One balance.** Your Shinjuku Shielded balance is a set of redeemable
  notes that you hold. The wallet shows it as one number.
- **Outside sellers work.** Any Solana x402 `exact` seller that takes USDC
  gets paid, whichever facilitator it uses (Coinbase CDP, PayAI, or any
  other). The seller changes nothing. Your wallet pays us privately, and we
  pay the seller from our own float. The chain shows Shinjuku paying the
  seller, never your wallet.

## What your agent gets

The private x402 facilitator, inside your agent.

Shinjuku Shield settles x402 payments from a shielded USDC balance on
Solana: on chain, a shielded payment does not show who paid. This MCP server
is how your agent uses it. It runs on your machine, under caps that only you
set.

- **Self-custody.** The server runs on your machine. Your keys never leave
  it. We never run it, and we never hold your money.
- **Shielded payments.** Your agent pays from a shielded balance. Add `--tor`
  and no server sees your IP.
- **One command to set up.** `npx -y --no-audit --no-fund shinjuku-shield@0.3.86 setup` makes the
  wallet, a private passphrase file, and the checked proof tools, and writes
  `config.json`. Then your agent host starts `npx -y --no-audit --no-fund shinjuku-shield@0.3.86 mcp`.
  `--no-audit --no-fund` stop npx from asking npm's audit and funding
  services when it installs a new version. Once, that request held the start for
  5 minutes.
- **Add funds from 0.01 USDC.** Ask your agent to add funds.
  `wallet_add_funds` gives a one-time address. Send USDC to it from any
  wallet or exchange, and it becomes private by itself.
- **Caps that only you set.** Spending limits are optional; by default there
  is none (only the balance bounds a payment). Setup records the ones you set.
  A tool call can only lower them, never raise them.
- **Find sellers.** `x402_discover` searches public x402 listings
  (Coinbase x402 Bazaar, PayAI, Dexter, and others) on your machine.
- **Pay any Solana `exact` seller.** A seller on Coinbase CDP, PayAI, or any
  other facilitator is paid through Shinjuku: your wallet pays us privately,
  and we pay the seller from our own float. Nothing to fill or set aside.
- **Look before you pay.** `x402_preview` shows the price and whether your
  caps allow it. It pays nothing.
- **No SOL.** `wallet_add_funds` and `wallet_shield` need only USDC. Our
  facilitator's relayer pays the network fee.
- **Never twice.** A retry with the same `request_id` resumes the same
  payment, deposit, or unshield. It never starts a second one.
- **No RPC, no sign-up, no API key.** Reads go through our relay by default.
  Your own RPC always wins if you give one.

This repository holds the setup guide, the [examples](examples/), the [docs](#docs), the
[changelog](CHANGELOG.md), and the published SHA-256 hashes of every wallet file and its proof tools
([Releases](#releases)). It holds no server code, no circuit code, and no wallet source code.

## Docs

- [How it works](docs/how-it-works.md): x402, our three schemes, the flow
  of one payment, and what runs where.
- [Privacy model](docs/privacy-model.md): what the chain, the seller, our
  facilitator, the RPC, and the MCP host see, with each limit.
- [Sell with Shinjuku Shielded](docs/sell-with-shinjuku.md): get paid by
  Shinjuku Shielded buyers with stock x402 middleware, and get listed.
- [Proof](docs/proof.md): live mainnet transactions, and what each one shows
  and hides.
- [FAQ](docs/faq.md): custody, cost, networks, Tor, recovery, and audits.
- [Changelog](CHANGELOG.md): what changed in each release. The first
  changelog of the wallet file, up to `08a4b56f` (npm 0.3.8):
  [changelog-to-0.3.8.md](docs/changelog-to-0.3.8.md).

## Release 0.3.86

Stable version, pinned 2026-10-23. A self-custody wallet for AI agents. It
pays any x402 endpoint from a shielded balance, so the chain does not show
which wallet paid. One command sets it up. Your agent does the rest from
plain requests.

| | |
|---|---|
| Pinned version | `shinjuku-shield@0.3.86` |
| Same files, older name | `shinjuku-shielded@0.3.86` |
| Wallet release | b650bf06 ([its hash](#releases)) |
| Network | Solana, USDC |

### Get started

You need Node.js 22.21 or newer, or Node.js 24. Tor is optional: run it if
you also want to hide your IP address.

1. **Set up the wallet.** One command makes the wallet on your machine, a
   private passphrase file, and downloads every proof file it needs (about
   191 MB, checked by hash). Add `--tor` to do the download and every later
   request over Tor.

   ```sh
   npx -y --no-audit --no-fund shinjuku-shield@0.3.86 setup
   ```

2. **Add it to your agent host.** Setup prints the exact lines for Claude
   Code, Claude Desktop, Cursor and other MCP hosts. The host then starts the
   wallet with:

   ```sh
   npx -y --no-audit --no-fund shinjuku-shield@0.3.86 mcp
   ```

3. **Add money.** Ask your agent "Add 1 USDC to my private balance." It gives
   you a one-time address. Send USDC on Solana to it from any wallet or
   exchange. You need no SOL. A few minutes after it arrives, the money is
   private.

4. **Use it.** Ask your agent to pay a URL, find a paid API, send money out,
   or ask an AI model. Every feature below works from a plain request.

For a terminal, install the wallet once:
`npm install -g --no-audit --no-fund shinjuku-shield@0.3.86`, then
`shinjuku-shield help` lists every command.

### Features

Every feature here passed a live run on the published 0.3.86 package, on
production, with real USDC, on 2026-10-23.

**Add money**

- **Add funds** (`wallet_add_funds`, `shinjuku-shield add-funds`). A new one-time
  address for each deposit, from 0.01 USDC. Send from any wallet or exchange;
  no SOL needed. The wallet makes it private by itself after it lands, even
  if your agent app closed. Ask: "Add 1 USDC to my private balance."
  Terminal: `shinjuku-shield add-funds --route exchange --amount 1`
- **Make public USDC private** (`wallet_shield`). USDC that sits on the
  wallet's own public address moves into the shielded balance. The
  facilitator pays the network fee. Ask: "Make the USDC on my address
  private."
- **Send any token privately** (`wallet_transfer_token`,
  `wallet_transfer_token_status`). Any token on the wallet's own address is
  sold for USDC, made private, and sent on in pieces. The receiver gets USDC
  with no link to the token wallet. Ask: "Sell my JUP for USDC and send it
  privately to my main wallet."

**Pay**

- **Pay any x402 endpoint** (`x402_pay`, `shinjuku-shield pay`, `shinjuku-shield curl`).
  Pays an x402 URL from the shielded balance and returns the answer. The
  seller gets paid as usual; the chain does not show which wallet paid. The
  price and the fee show in the answer. Ask: "Pay for this endpoint and show
  me what it returns: <url>"
- **Price preview** (`x402_preview`). Shows what a URL costs before you pay.
  Nothing is paid or signed. Ask: "How much does this URL cost?"
- **Find paid APIs** (`x402_discover`). Searches public x402 endpoints for a
  job. Your search words stay on your machine; nothing is paid. Ask: "Find a
  paid API for Brazil inflation data."
- **Automatic refunds** (`x402_pay`). If the seller fails before it takes the
  money, the full amount comes back to the private balance by itself. If the
  seller took the money and gave nothing, the receipt says so with the
  seller's transaction. Nothing to ask: the receipts show each refund and its
  transaction.
- **Slow sellers, never paid twice** (`x402_pay`). When a seller is slow, the
  wallet answers early and keeps waiting. Asking again with the same request
  continues the same payment. It never pays twice. Ask again with the same
  request when the agent tells you the seller is still working.
- **Images and files** (`x402_pay`). A paid answer that is an image or a file
  is saved in the wallet folder, with its path and hash. Ask: "Buy a QR code
  for this text from <url>."
- **Cancel** (`wallet_cancel`, `shinjuku-shield cancel`). Closes a payment that can
  no longer settle, so its reserved money comes back. A finished payment
  cannot be taken back, and the wallet says so. Ask: "Cancel that payment."

**Send money out**

- **Send to an address** (`wallet_unshield`, `shinjuku-shield unshield`). Sends some
  or all of the private balance to any Solana wallet as plain USDC. The
  facilitator pays the network fee. Ask: "Send my whole private balance to my
  main wallet." Terminal: `shinjuku-shield unshield --amount all --to <address>`
- **Send in pieces at random times** (`wallet_unshield` with a time
  window). Splits a send into pieces that leave at random times, so the
  amount and the time do not match one payment. The pieces go out in the
  background, even after your agent app closes. Ask: "Send 0.02 USDC to
  my main wallet in 2 pieces within the next 10 minutes."
- **Send all of it** (`wallet_unshield`, `shinjuku-shield unshield --amount all`). A
  balance from several deposits is readied by itself when you send all of it.
  You do nothing extra. Ask: "Send all of it."
- **Spend a received payment** (`wallet_unshield`). A wallet that only
  received private payments can send them out directly, with no extra step.
  Ask: "Send what I received to <address>."

**Your wallet**

- **Balance** (`wallet_balance`, `shinjuku-shield balance`). One number: what you can
  spend. It also shows any public USDC on the wallet's own address and any
  money still on its way. Ask: "What is my private balance?"
- **Receipts** (`wallet_receipts`). Every payment, refund, deposit and send,
  newest first, with the seller, the price, the fee and the transactions.
  Ask: "Show my receipts from today. Did I get my money back on failed
  payments?"
- **Spending limits** (`--max-payment`, `--max-session`, `shinjuku-shield limits`).
  Optional limits per payment and per 24 hours. A payment over a limit is
  refused before anything is paid, and the answer says how to change the
  limit. Set them in setup or in your host's MCP entry, for example
  `--max-payment 0.05`.
- **Version pin and update notice** (`npx ... shinjuku-shield@0.3.86 mcp`).
  Your host runs the exact version it names. When a new release is ready,
  the wallet tells you to restart. Nothing to ask.

**Private AI**

- **Ask an AI model** (`inference_chat`). Your agent asks an AI model and pays
  for the answer from the shielded balance. The chain does not show which
  wallet paid. Ask: "Ask a private AI model: what is the capital of France?"
- **Terminal chat** (`shinjuku-shield chat`). A private AI chat in your terminal. The
  conversation stays in memory only and is gone when you exit. Terminal:
  `shinjuku-shield chat`, then `/cost` and `/exit`
- **One question** (`shinjuku-shield infer`). One question, one paid answer, no setup
  flags. Terminal: `shinjuku-shield infer "Say hello"` or
  `echo "Say hello" | shinjuku-shield infer -`
- **Private AI address for your apps** (`shinjuku-shield infer start`,
  `inference_server`). A local OpenAI-compatible address
  (`http://127.0.0.1:11402/v1`) with an API key. Any app that speaks the
  OpenAI chat API, streaming included, gets private paid answers. It runs in
  the background after the terminal closes, but not after the computer
  restarts: then run `shinjuku-shield infer start` again (the API key
  stays the same). Ask: "Start my local private AI address." Terminal: `shinjuku-shield infer start`, `shinjuku-shield infer status`,
  `shinjuku-shield infer stop`

**Privacy and setup**

- **Tor** (`setup --tor`, `--tor`, `--no-tor`). With Tor, every request goes
  through Tor and reaches the facilitator through its onion service, so no
  server sees your IP address. After a Tor setup, every command uses Tor by
  itself. Run Tor with `HTTPTunnelPort 127.0.0.1:9080`, then `setup --tor`.
- **Self-custody** (`shinjuku-shield setup`, `backup-export`). The keys are made and
  kept on your machine. Only your keys move your balance. The facilitator
  settles and pays network fees; it never holds your money. Back up after
  setup: `shinjuku-shield help backup-export`
- **The terminal command**
  (`npm install -g --no-audit --no-fund shinjuku-shield@0.3.86`). Every
  wallet action from a terminal: setup, add-funds, balance, pay, unshield,
  chat, infer and more. Terminal: `shinjuku-shield help`

### Speed

The time from "pay" to the seller's data, for the first payment to a seller
the wallet never paid before (a fresh wallet process, production,
2026-10-23):

| Route | First seller | Second seller |
|---|---|---|
| Direct | 4.85 s (payai.agentstools.dev) | 11.31 s |
| Over Tor | 9.94 s (werner.ddns.net) | 18.14 s |

### Known issues

None of these loses money. Each one gets its own fix release, tested live
before the next.

1. When a seller fails before it takes the money, the answer starts with
   "Paid". The money is not taken and comes back by itself.
2. The terminal send prints one internal line that starts with
   `SELLER_STORE`.
3. `shinjuku-shield chat` can print raw Tor lines while Tor is slow.
4. When the spending limit comes from the host's MCP entry, the refusal names
   setup as the place to change it.
5. Before a send that needs the balance readied first, the agent may not
   tell you it takes about 2 minutes.
6. In a terminal, balance, infer and unshield print internal Tor, RPC and
   history lines.
7. A plain `shinjuku-shield balance` right after a deposit can show no number.
   `shinjuku-shield balance --refresh` shows it.

Payments to outside sellers show the price and the seller on chain as any
x402 payment does; what the chain does not show is which wallet paid. Every
release and its changes: [CHANGELOG.md](CHANGELOG.md).
## Talk to it in plain words

Ask your agent the way you would ask a person:

| You say | Your agent calls |
|---|---|
| "what is my balance" | `wallet_balance` |
| "add 0.50 USDC to my shielded balance" | `wallet_add_funds` |
| "shield 5 USDC" | `wallet_shield` |
| "find a seller of satellite images" | `x402_discover` |
| "pay this URL" | `x402_preview`, then `x402_pay` |
| "ask an AI model privately" | `inference_chat` |
| "send 2 USDC privately to <address>" | `wallet_unshield` |
| "sell my JUP and send the value privately to <address>" | `wallet_transfer_token` |

Each answer tells the agent the exact next call. The wallet reads the chain
and writes an encrypted backup by itself, so you never run a command for
upkeep.

## Tools

### SETUP

On a machine with no wallet, the server starts in setup mode.

| Tool | What it does |
|---|---|
| `shinjuku_setup` | Asks you to confirm in your MCP client that it may create a Shinjuku Shielded wallet on this machine, and shows the caps. Then it runs the setup and switches the same server to the wallet tools. It never asks for a secret. A client that cannot ask is told to run `npx -y --no-audit --no-fund shinjuku-shield@0.3.86 setup` in a terminal. |
| `wallet_status` | Says whether the wallet is set up, and what to do next. |

In setup mode, every money tool answers `wallet_not_set_up` and does
nothing.

### FUND

| Tool | What it does |
|---|---|
| `wallet_add_funds` | Gives a new one-time Solana address of this wallet and a `solana:` pay link. Send USDC to it from any wallet or exchange, from 0.01 USDC. You need no SOL. A few minutes after the USDC arrives, it becomes private by itself while the MCP server runs. One round takes up to 5 USDC; a larger amount goes in by rounds. Use each address for one payer. The call itself moves no money. |
| `wallet_shield` | Moves USDC that is already on the wallet's own Solana key into your shielded balance: any amount from 0.01 USDC, while the shielded balance stays at most 5 USDC. It is a public step: the chain shows the wallet's own key. It is on with `--proof-tools`. `--no-shield` turns it off. Funding takes minutes: the first call starts it and returns a stage. Call again with the same `request_id` to see the stage. It never starts a second deposit. When the deposit lands, the wallet reads it from the chain and writes an encrypted backup. The wallet's own key needs the USDC and no SOL: our facilitator's relayer pays the network fee, and you pay the shield cost. |

### PAY

| Tool | What it does |
|---|---|
| `x402_discover` | Searches public x402 listings (Coinbase x402 Bazaar, PayAI, Dexter, and others) on your machine and returns the sellers that match. Pays nothing. The first call takes about 15 s. |
| `x402_preview` | One unpaid request. Returns the seller's price, the scheme, and whether your caps allow it. Pays nothing. For a standard `exact` seller it adds `feeAtomic` (our fee) and `totalAtomic` (price plus fee, what leaves your balance). A seller that lists several networks is priced from its Solana offer. |
| `x402_pay` | Pays the URL (if it asks for payment) and returns the answer. A URL that does not answer 402 is fetched once and nothing is paid. An image answer (image bytes, or JSON `image_base64`) comes back as an MCP image block, and the file is saved. A payment that landed, from a seller that gives no answer, closes as paid. If a standard `exact` seller does not take our payment, the answer is `p03_float_refund_pending`: price and fee come back to your balance by themselves within about 7 minutes. Alias: `fetch_paid`. |
| `inference_chat` | One AI answer from usePod's x402 chat endpoint, paid privately from your shielded balance. A short `qwen3-8-flash` answer costs about 0.0011 USDC: the provider price plus the 0.001 USDC Shinjuku fee. It needs `--tor` or a proxy. |

### UNSHIELD

| Tool | What it does |
|---|---|
| `wallet_unshield` | Sends shielded USDC to a public Solana address. It is on with `--exit-proof-tools` and `--profile`. Our facilitator pays every network fee. The same `request_id` never unshields twice. An address that you named with `--unshield-to` is sent at once. Any other address is sent only after you confirm it in your MCP client: "Send X USDC from your shielded balance to <address>?". A decline, or no answer in 5 minutes, sends nothing. A client that cannot ask is refused, so a prompt injection cannot pick an address by itself. The wallet's own key is refused: it made the deposits, so an exit there would link them. |

### WALLET

| Tool | What it does |
|---|---|
| `wallet_balance` | ONE balance (`balanceAtomic`, what `x402_pay` can spend) and UNSHIELDED (`unshieldedAtomic`, plain USDC on the wallet's own Solana key), with `ownAddress` and `status` (`"current"` when the balance is read). `breakdown` names what the one balance holds: `shieldedAtomic` (what `wallet_unshield` can send), `refundsInFlightAtomic` (a Shinjuku refund on its way back), and `setAsideAtomic` (value in pockets of an older version). A stale balance is read from the chain first. UNSHIELDED is one network read; if it fails, that line is empty and says why. |
| `wallet_receipts` | Your most recent paid receipts: `{ok, count, total, facilitatorNote, receipts}`. Each receipt has `kind` (`x402`, `inference`, or a move), the host (never the full URL), `amountAtomic`, and `transaction`. |
| `wallet_cancel` | Closes one unfinished payment (its reserved balance comes back), the pieces of a private send that did not start, or an add-funds link that no USDC reached. |

### RECEIVE AND TRADE

| Tool | What it does |
|---|---|
| `wallet_receive_shielded` | Gives a new one-time private (shielded) address of this wallet, for a Shinjuku Shielded payer in the same pool. It stores, signs, and moves nothing. A wallet that never shielded can spend what it receives only after one shield; the answer says so in `notice`. |
| `wallet_transfer_token` | Sells a Solana token for USDC (on Jupiter), makes the USDC private, and sends it privately to an address. The address gets USDC, not the token. It takes minutes. The stages are `selling`, `shielding`, `sending`, and `done`. |
| `wallet_transfer_token_status` | Shows the stage of one transfer by `request_id`, or the list of transfers. |

`wallet_shield` and `wallet_unshield` always appear in the tool list. When
one is off, it answers `"error": "mcp_tool_disabled"` and tells the agent
what to ask you.

The tool list shows 12 of the tools above: `wallet_receive_shielded` is not
in the list from 0.3.54 (it comes back with private escrow deals), but it
still answers when an agent calls it by name. Some older tools are not in
the list either, and they also answer by name:
`wallet_shield_from_elsewhere`, `wallet_pay_me`, `wallet_pay_me_status`,
`wallet_unshield_cancel`, `wallet_move_status`, and `inference_models`.

What it pays:

- **`shielded-exact`**, from your shielded balance, whenever the seller
  offers it.
- **Standard Solana `exact`, through Shinjuku (float pay).** For a seller on
  any facilitator (Coinbase CDP, PayAI, or any other), `x402_pay` pays us
  privately from your shielded balance: the seller's price plus a flat fee
  (`feeAtomic`, 0.001 USDC on 2026-10-22). We pay the seller at once from our
  own shared float. The chain shows Shinjuku paying the seller, never your
  wallet. `max_payment_atomic` must cover price plus fee. The largest price
  that one request can pay is `largestAtomic` in
  `GET https://pay.shinjukustaition.com/api/x402/float/config` (10 USDC on
  2026-10-22).
- A retry with the same `request_id` never pays twice.

Hidden amounts (scheme `confidential`, the V0b vault) are retired: the V0b
program was closed on chain on 2026-10-11.

Value that an older version put in pockets still counts in the one balance.
When the server has `--proof-tools`, `--exit-proof-tools`, and `--profile`,
it returns that value to the shielded balance by itself while it is idle.
`shinjuku-wallet pocket reshield` does the same by hand.

A balance from several deposits: one payment can spend only a few of them
at once. The server gathers them into one by itself (a private payment to
itself; nothing leaves the shielded balance, and our facilitator pays the
network fee). When no single deposit covers a price yet, `x402_pay` says
so, the gathering starts within about a minute, and the answer says when
to pay again.

## Privacy modes

| | Default | `--tor` |
|---|---|---|
| On chain | A shielded payment does not show who paid. | The same. |
| Your IP | Payments go to `pay.shinjukustaition.com`, with no CDN in the path. Our server sees your IP. It keeps no access logs. | Hidden from everyone, us included. |
| The seller | Sees your IP. | Does not see your IP. |
| Speed | Faster. | About 1-2 s slower per request. |
| Needs | Nothing extra. | Tor with `HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr` in `torrc`. |
| When a path is slow | - | The wallet races our onion addresses and keeps the first that answers. A facilitator onion that gives no answer in 15 s brings in two spare onions. A history request with no answer moves to the next history onion, and a history source that is silent for 60 s ends with a plain error instead of a long wait. A stalled Tor circuit is replaced. A facilitator request never falls back to our clearnet address. |

## Setup

You need Node.js 22.21 or later (or Node.js 24 or later), on Windows or Linux. macOS is not supported
yet.

The stable version is `shinjuku-shield@0.3.86` (pinned 2026-10-23; the same files are on npm as
`shinjuku-shielded@0.3.86`), and every command here names it. Setup prints host lines that name this exact
version. A candidate is out for testing: `shinjuku-shield@0.3.102` (npm tag `next`,
2026-10-24). It fixes known issues 1 to 7 of 0.3.86, shows a QR code for a
deposit, asks for your own wallet address in setup, asks "Use Tor?" when
your agent app sets up the wallet, waits for your answer in the setup box,
names your recovery file when setup ends, says when you confirmed a send,
and asks for each value in a terminal instead of a flag. It adds slash
commands in Claude Code: type / and pick a command, then add its value, or
press Enter and the agent asks. It gives you the `shinjuku` command for a
terminal (`npm install -g --no-audit --no-fund shinjuku@0.3.102`, then
`shinjuku help`). The private AI chat and the private AI address use one
default model, `qwen3-8-flash`, with 4096 tokens for an answer; the address
names its model and says what to do after a restart. When a seller refuses a payment at once, it
says when the refund lands. See the [changelog](CHANGELOG.md).

A later stable version gets its own row in the
[Releases table](#releases): run its setup once and
put its version in your host's config. Your wallet, its address, and its balance stay the same.

### 1. Run the setup in a terminal

```sh
npx -y --no-audit --no-fund shinjuku-shield@0.3.86 setup
```

It asks for the caps (Enter keeps the default) and Tor. `--yes` asks
nothing. `--add-to claude-code` (or `claude-desktop`, `cursor`) also adds
the server to that host's config. In our runs, setup took about 10-16 s on a
fast line, with the proof-tool download of about 191 MB. Over Tor (`--tor`),
it took 89 s to 5 min in our 0.3.86 tests (2026-10-23). At the end it prints a
summary, for example:

```
Shinjuku Shielded is set up.
  limits       no limit per payment, no limit in any 24 hours, no limit for the life of the wallet
  config       <home>/config.json
  passphrase   <home>/passphrase.txt (a new random passphrase; only you can read the file; it is never printed)
  proof tools  <home>/proof-tools/a9af32df (29 files downloaded, every hash checked)
  wallet       created; your public address (solanaFeePayer): <address>
  recovery     <home>/recovery-<time>.txt
```

Setup writes to `~/.carbon-shielded-wallet` (or `SHIELDED_WALLET_HOME`):

- The wallet, and a recovery file with the seed and the key. Copy the
  recovery file to two offline places, then delete it from this machine.
- `passphrase.txt`: a new random passphrase, readable by you alone. It is
  never printed, and no tool takes or returns it. Keep it: the wallet file
  opens only with it.
- The proof tools. Setup checks every file against the set that this wallet
  release pins.
- `config.json`: the caps, the paths, and Tor. With it, `mcp` needs no
  flags. A flag on the command line still wins.

Spending limits are optional and off by default: with none, only the balance
bounds a payment. To set them, give `--max-payment`, `--max-session`, or
`--max-cumulative`, in USDC (`0.05` = 5 cents). A setup rerun lifts the
old default caps (0.05 / 1 / 20 USDC) of earlier versions. `--prefer-tor`
records Tor (see Privacy modes).

You can run `setup` again at any time. It never changes an existing wallet,
and it checks every proof-tool file again.

### 2. Add the server to your agent host

If you gave `--add-to`, this step is done. Setup also prints these lines.

Claude Code:

```sh
claude mcp add --scope user shinjuku-shielded -- npx -y --no-audit --no-fund shinjuku-shield@0.3.86 mcp
```

On native Windows, the line that setup prints puts `cmd /c` before `npx`.
With a wallet folder that is not the default, it adds
`-e SHIELDED_WALLET_HOME=<home>` (or an `"env"` block in JSON).

Claude Desktop (`claude_desktop_config.json`), Cursor (`~/.cursor/mcp.json`),
and other JSON-config hosts:

```json
{
  "mcpServers": {
    "shinjuku-shielded": {
      "command": "npx",
      "args": ["-y", "--no-audit", "--no-fund", "shinjuku-shield@0.3.86", "mcp"]
    }
  }
}
```

### Or: start the server first and accept the setup

You can also add the server first, with no wallet on the machine. Then the
server starts in setup mode. Ask your agent "what is my balance". Your MCP
client asks you to confirm: create a Shinjuku Shielded wallet on this
machine. Accept, and the setup runs (with the proof-tool download of about
191 MB). Then the same server switches to the wallet tools. You do not
restart it. A client that cannot ask is told to run
`npx -y --no-audit --no-fund shinjuku-shield@0.3.86 setup` in a terminal.

In a terminal, `npx -y --no-audit --no-fund shinjuku-shield@0.3.86 mcp` asks
"Set up Shinjuku Shielded now? (y/n)".

### 3. Add funds

The wallet starts empty. Ask your agent "Add 0.50 USDC to my shielded
balance". It calls `wallet_add_funds` and gives a one-time address. Send
that USDC on Solana from any wallet or exchange. Amounts from 0.01 USDC
work, and you need no SOL. The USDC becomes private by itself while the MCP
server runs: our relayer pays every fee.

From an exchange, in a terminal, whole USDC only:

```sh
npx -y --no-audit --no-fund shinjuku-shield@0.3.86 add-funds --route exchange --amount 2
```

It prints a one-time address. Withdraw exactly that amount of USDC (Solana
SPL) from the exchange to it, and it shields the USDC by itself. `--amount`
is a whole number of USDC (`2` = 2 USDC).

USDC that is already on the wallet's own address (`ownAddress` in
`wallet_balance`) goes in with `wallet_shield`. The steps are in
[First 10 minutes](examples/README.md#first-10-minutes).

### Advanced: download the file and check it

Download the release file and check its SHA-256 before you run it. The
current file and hash are also in the
[Releases table](#releases)
and in section 7b of https://shinjukustaition.com/skill.md.

```sh
curl -fsSLO https://shinjukustaition.com/wallet/b650bf06/shinjuku-wallet.mjs
echo "b650bf0682830e05207f52bad2ba426ec7f8fa1bbbfdb7e028057865e3d83d24  shinjuku-wallet.mjs" | sha256sum -c -
node shinjuku-wallet.mjs setup
```

With the file, replace `npx -y --no-audit --no-fund shinjuku-shield@0.3.86` with
`node /abs/path/shinjuku-wallet.mjs`.

### Advanced: flags instead of config.json

`mcp` reads `config.json` only when you give no `--pool` and no `--wallet`.
To give the flags yourself (for example, for a wallet that you made with
`init` before 0.2.0):

```sh
claude mcp add --scope user shinjuku-shielded -- npx -y --no-audit --no-fund shinjuku-shield@0.3.86 mcp \
  --max-payment 0.05 --max-session 0.2 --tor \
  --pool <pool> \
  --program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1 \
  --memo-service https://pay.shinjukustaition.com \
  --proof-tools /abs/path/shinjuku-proof-tools/proof-tools.json \
  --exit-proof-tools /abs/path/shinjuku-proof-tools/exit-proof-tools.json \
  --profile /abs/path/shinjuku-proof-tools/public-profile.json \
  --passphrase-file /abs/path/passphrase.txt
```

With `--pool`, `--program` and `--memo-service` are required. Setup writes the pool, the program, and the
facilitator into `config.json`: `<pool>` is the pool in your `config.json`.
`npx -y --no-audit --no-fund shinjuku-shield@0.3.86 help mcp` prints every flag.

Use absolute paths: a host starts the server from its own folder. On Windows,
write `C:/Users/you/...`. `--proof-tools` turns `wallet_shield` on.
`--exit-proof-tools` and `--profile` turn `wallet_unshield` on.

For an older wallet, you can also run `setup` once with
`SHIELDED_WALLET_HOME` set to your wallet folder and `--passphrase-file`
set to your passphrase file. It keeps your wallet and writes `config.json`
beside it.

A send to a new address needs a host that supports MCP elicitation (it shows
you the confirmation). With a host that does not, name each address with
`--unshield-to`.

## Examples

[examples/](examples/) has complete configs and a walkthrough:

- [Claude Code](examples/claude-code.md): the setup command, the
  `claude mcp add` command, Tor, each flag explained, and how to check it
  works.
- [Claude Desktop](examples/claude-desktop.json) and
  [Cursor](examples/cursor.json): complete JSON configs.
- [Hermes Agent](examples/hermes.md): the `config.yaml` entry.
- [Vercel AI SDK](examples/vercel-ai-sdk.md): the server's tools in
  `generateText` through `@ai-sdk/mcp`, with no other package.
- [Solana Agent Kit](https://github.com/ShinjukuStaition/shinjuku-sak-plugin):
  npm `solana-agent-kit-plugin-shinjuku`, the wallet as Solana Agent Kit v2
  actions.
- [First 10 minutes](examples/README.md#first-10-minutes): set it up, add
  the server, add funds, pay, send, and check the balance.
- [Plain requests](examples/prompts.md): 13 requests, the tool each one
  calls, and the shape of the answer.

## Caps and flags

After setup, `config.json` holds the caps and the paths. You can add any of
these flags to the `mcp` command. A flag wins over `config.json`.

| Flag | |
|---|---|
| `--max-payment <usdc>` | Optional. The most one payment may cost, in USDC (`0.05` = 5 cents). Setup records it. Default: no limit. |
| `--max-session <usdc>` | Optional. The most this wallet may pay in any 24 hours, from every MCP process together. When you set both, it must be at least `--max-payment`. Setup records it. Default: no limit. |
| `--max-per-host-day <usdc>` | Optional. The most one seller host may receive in 24 hours, in USDC. |
| `--allow-host <host>` | Optional, repeatable. Pay only these seller hosts. |
| `--no-shield` | Optional. Turns `wallet_shield` off. It is on with `--proof-tools`. |
| `--max-shield <usdc>` | Optional. The most one shield call may move, and the most this wallet may shield in any 24 hours, in USDC. Without it, no cap beyond the balance. |
| `--allow-shield` | Accepted for older configs. `wallet_shield` is on without it. |
| `--exit-proof-tools <file>`, `--profile <file>` | Optional. Turn `wallet_unshield` on (with `--proof-tools`). |
| `--unshield-to <address>` | Optional, repeatable. These addresses receive with no confirmation. Any other address needs your confirmation in the MCP client. The wallet's own key is refused: the server does not start when you name it here. |
| `--ready-pockets <0-5>` | Accepted for older configs and ignored. Standard `exact` sellers are paid through Shinjuku, and the wallet fills no pocket. |
| `--no-auto-pockets` | Accepted for older configs. It also stops the idle return of old pockets to the shielded balance. |
| `--max-unshield <usdc>` | Optional. The most one unshield call may move, and the most this wallet may unshield in any 24 hours, in USDC. Without it, a send you confirm can move the whole shielded balance. |
| `--no-tor` | Optional. This run does not use the Tor that setup recorded. |
| `--tor` | Optional. Every request goes through Tor; our facilitator is reached over its onion service. Needs Tor with `HTTPTunnelPort 127.0.0.1:9080` in `torrc`. See Privacy modes. |
| `--rpc-file <file>` | Optional. Your own Solana RPC URL. Without it, reads go to our relay, which sees which addresses the wallet reads. |

The passphrase comes from `--passphrase-file` or `SHIELDED_WALLET_PASSPHRASE`
at start, never from a tool call. A refusal is a normal answer
(`{"ok": false, "error", "detail", "next"}`); the agent does what `next`
says. A cap refusal tells the agent to ask you: only you set the caps.

An unshield is your own money, so it does not count against the payment
budget of the wallet file (`init --max-payment`, `--max-cumulative`).
Payments to sellers still count. To show, change, or remove those
wallet-file caps, run `shinjuku-wallet limits` (`none` removes a cap). A
refusal by one of them tells the agent to ask you for this.

Upkeep is automatic. After a deposit lands, and before a payment or unshield
when the local balance is stale, the server reads the chain itself. By
default it reads the pool history through our facilitator's https history
proxy: a new wallet is ready in about 60 s. After
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
- On chain, a `shielded-exact` payment does not show who paid. A float pay
  payment is a pool payment to us (the payer hidden), then a normal USDC
  transfer from a Shinjuku float pocket to the seller. Many buyers pay from
  the same float pockets. The transfer lands seconds after the pool payment,
  so time can pair the two.
- For a float payment, our server sees which private payment paid which
  seller, the price, the URL, and the time, until the payment is final or
  refunded. It does not see your wallet.
- `wallet_add_funds`: the chain shows the USDC that arrives at the one-time
  address, the amount, and the time. Use each address for one payer.
- `wallet_shield` is a public step: the chain shows USDC leave the wallet's
  own key, the amount, and the time.
- `wallet_unshield` is a public step: the chain shows the amount, the
  address that receives it, and the time.
- `inference_chat`: usePod and the model provider see the prompt and the
  answer.
- The UNSHIELDED line of `wallet_balance` reads the wallet's own key. The RPC
  (our relay by default) sees which key it reads.
- Privacy needs a crowd. With few users, timing can still link payments.

## Which endpoints you can pay

- **A seller whose 402 offers `shielded-exact`.** The wallet pays it from
  your shielded balance, and our facilitator settles the payment.
- **Any other Solana x402 `exact` endpoint that takes USDC, whichever
  facilitator settles it (float pay).** `pay` (or the MCP `x402_pay`) pays
  us privately from your shielded balance: the seller's price plus a flat
  fee of 0.001 USDC. We then pay the seller at once from our own shared
  float. You fill nothing and set nothing aside. If the seller does not take
  the payment, we refund price and fee to your shielded balance by ourselves.
  This path, and every other payment, needs wallet release `08a4b56f` (npm
  `shinjuku-shielded@0.3.8`) or later: the pool program was upgraded on
  2026-10-11, and earlier releases refuse to pay.

The largest price that float pay can pay for one request is the size of our
largest float pocket. Read it, and the fee, before you pay:

```sh
curl -fsS https://pay.shinjukustaition.com/api/x402/float/config
```

`feeAtomic` is the fee and `largestAtomic` is the largest price, in atomic
USDC (1000000 = 1 USDC). On 2026-10-22 they were `1000` (0.001 USDC) and
`10000000` (10 USDC). A higher price is refused before anything is paid
(`p03_float_price_above_capacity`).

The 3D market game [Shinjuku Undermarket](https://shinjukustaition.com) is
our first customer and our live demo.

## Status

- Stable version (pinned 2026-10-23): wallet release `b650bf06`, npm
  `shinjuku-shield@0.3.86` (the same files as `shinjuku-shielded@0.3.86`).
  Install that exact version. It adds private AI in the terminal and for
  agent apps.
  Every feature and how to use it: the
  [0.3.86 release notes](#release-0386).
  Hash: the `b650bf06` row of [Releases](#releases).
- The stable version before it: wallet release `98296ff0` (npm 0.3.80).
- Candidate (2026-10-24, not the stable version): wallet release `3a984162`, npm
  `shinjuku-shield@0.3.102` under the tag `next`. It fixes known issues 1 to 7 of
  0.3.86, shows a QR code for a deposit, takes any amount from 0.01 USDC in a
  terminal, keeps every tool text short enough for agent apps to read in full,
  asks "Use Tor?" when an agent app sets up the wallet, waits for your answer
  in the setup box, names your recovery file when setup ends, says when you
  confirmed a send, and asks for each value in a terminal instead of a flag.
  It adds slash commands in Claude Code (type / and pick a command, then add
  its value, or press Enter and the agent asks), the `shinjuku` command for a
  terminal (`npm install -g --no-audit --no-fund shinjuku@0.3.102`), one default AI model
  (`qwen3-8-flash`, 4096 tokens for an answer) for the chat and the private AI address, and the
  time when a refund lands after a seller refuses at once.
- `shielded-exact` payments from the shielded balance: live on mainnet.
- Float pay to any Solana x402 `exact` endpoint that takes USDC: live on
  mainnet since 2026-10-11 (wallet release `e3348092` and later). On
  2026-10-11 it paid two stock sellers on the PayAI facilitator, 0.10 USDC in
  15 s and 1.50 USDC in 20 s, and a stock seller on our own facilitator
  (`488372b4` and later), 0.01 USDC in 16 s and 17 s: see
  [proof.md](docs/proof.md).
- Faster pool anchors: live on mainnet since the pool program upgrade of
  2026-10-11 (wallet release `08a4b56f` and later). The pool takes an anchor
  about every 30 s when it grew. In our test, 12 of 12 new deposits could pay
  within 45 s (median 18 s).
- Pool moves: live from wallet release `701809bd` (npm `shinjuku-shielded@0.3.9`). When we open a new
  pool, the old pool keeps serving until it is empty, and `move` moves your
  whole balance to the new pool privately: you pay our float in the old pool, and the float pays you
  in the new pool. Nothing goes through a public address.
- Per-user pockets: replaced by float pay. The wallet fills no new pocket
  for a payment. `pocket reshield` returns the USDC of an old pocket to your
  shielded balance.
- Hidden amounts (scheme `confidential`, the V0b vault): retired. The V0b
  program was closed on chain on 2026-10-11.
- The wallet file and its proof tools, served from our site and our onion
  service with SHA-256 hashes: live.
- Key ceremonies: a multi-party ceremony: not yet.
- Independent audit: none yet.

Listed in the official [MCP Registry](https://registry.modelcontextprotocol.io/v0/servers?search=io.github.ShinjukuStaition/shinjuku-mcp)
as `io.github.ShinjukuStaition/shinjuku-mcp`. npm: [`shinjuku-shield`](https://www.npmjs.com/package/shinjuku-shield) (also as `shinjuku-shielded`),
published from this repository's workflow with npm provenance (from 0.1.1).

Live on Solana mainnet. The current wallet release is `b650bf06` (npm
0.3.86, pinned 2026-10-23). Every feature and how to use it: [Release 0.3.86](#release-0386).

Every release and its changes: [CHANGELOG.md](CHANGELOG.md).

Float pay paid two stock sellers on the PayAI facilitator on
production on 2026-10-11, 0.10 USDC and 1.50 USDC, and a stock seller on our
own facilitator, 0.01 USDC twice: the transactions are in
[proof.md](docs/proof.md).

These transactions were made with real money through this MCP
server, against our production facilitator, on an earlier pool (retired
2026-10-10). The first two came from a new wallet with the default
setup and no SOL at any time (wallet release `94a357bc`). The others used
wallet release `1a336885` (2026-10-08).

| Tool | Transaction |
|---|---|
| `wallet_shield` (no SOL) | [`5np1EYjN…fH2`](https://solscan.io/tx/5np1EYjNkr5w7Tt6ng2KQ9cp7RgNkhpwAKtzkm2nyRKMgi1FsmM3TMZMx8EkyiAV4sUtoQ3mTtTbuehas1qV3fH2) |
| `x402_pay` to a public satellite-imagery seller (0.013 USDC, JPEG answer in 8 s) | [`iC6gnjFM…DHwC`](https://solscan.io/tx/iC6gnjFMBwHaqArgcRL6C5GdNbcWMom82cZqcQ2C2xup9aXJX91HXmWozQcVvAyTSTZsRptynfdbBPjjxG9DHwC) |
| `wallet_shield` (1 USDC in) | [`hWzDiR1R…izn`](https://solscan.io/tx/hWzDiR1RnC1gFXMMrCxRBCZ4R5dgMreWGX7vyQCTUTWkKaKnYvxmro6PQuE9KMYVbrq3NkNu9YaJzj7XaqrDizn) |
| `wallet_unshield` (0.5 USDC out) | self-pay [`5evVHz8X…r9uv`](https://solscan.io/tx/5evVHz8XvMdSYF76BQ1xv3TazwS9P38FEXp81gipNMMSqn61Rj7EUc1DdgpYz591wQbBZMWcpNVznixXPsfZr9uv) · exit [`4yY2YXLS…pgF2i`](https://solscan.io/tx/4yY2YXLSj1EyUWDb7X9985KmyeNGQieF8skg3uN3sv3Pds3zSb42J5owDWMUTshui6XACkP4zwGxUmXXTVapgF2i) |
| `wallet_unshield` with your confirmation (0.25 USDC, release `1a336885`) | self-pay [`3jQyPgrA…QEWw`](https://solscan.io/tx/3jQyPgrA5AtFcqzyWHDWRcfNv66sM5qfCStxsByYDqGm7W5uRWkUMHpLoFUFm2jc98Aor7CXSToAChSHD7dWQEWw) · exit [`4yA3qkHU…jCoh`](https://solscan.io/tx/4yA3qkHUto7e7iUGM9q6321avTm8aZQJ6zNMMh18SoAACnvgtvbWpVydry3mCq9iKaSZv92FfH43NJu557zjCoh) |
| `x402_pay` (pocket `exact`, before float pay) | [`kX2zbbuR…8wW`](https://solscan.io/tx/kX2zbbuRbskBQ2EnazyDBu7oZ7BtySVT7zDmtBn7ZivMm3guhLWrJGiPFFLzTEyxwTKUkeSAJjTJLSWLHYP48wW) |

No unshield transaction contains the wallet that shielded; our facilitator
paid every network fee of each unshield.

Full guide: https://shinjukustaition.com/skill.md ·
Onion: http://2kfhlfuyuwvhmibjrpxqsg4nrbcxasjgjq7kmnfzgfwzptkhhznz3dad.onion/skill.md ·
X: [@Shin_StAItion](https://x.com/Shin_StAItion)

## Releases

Each release is one file, `shinjuku-wallet.mjs`, and a set of proof tools.
Our website serves the files and their SHA-256 hashes at
`https://shinjukustaition.com/wallet/<sha8>/` and
`https://shinjukustaition.com/proof-tools/<sha8>/`. This repository is a
second, separate place for those hashes: each release adds its row here.

The stable version is `b650bf06`, on npm as `shinjuku-shield@0.3.86` and
`shinjuku-shielded@0.3.86` (pinned 2026-10-23). Use it for a new install. A row marked "candidate" is a newer
release served beside the stable version and published on npm under the
tag `next`, not `latest`; it becomes the stable version only when we say so here. Rows
marked "no longer served" are gone from the website; the other older rows
stay for the record. Some short-lived releases served between 2026-10-05 and
2026-10-07 have no row here. What changed in each release after `08a4b56f`
is in the [changelog](CHANGELOG.md).

| Released (UTC) | Wallet release | Wallet file SHA-256 | Bytes | Proof tools | SHA-256 of the proof-tools file list | Proof-tools files |
|---|---|---|---|---|---|---|
| 2026-10-02 | `68aac3c1` (no longer served) | `68aac3c1f7bcf9e21c44637c5db4cef3ad8ed52732cd5634f0884d1417a78b1d` | 9,476,013 | [`864898cb`](https://shinjukustaition.com/proof-tools/864898cb/SHA256SUMS) | `864898cb1a7db74c54bc567307795ba154f2b8ed70e36a1336bf8c6c06c5c702` | 29 (183,830,695 bytes) |
| 2026-10-05 | `f561eccf` (no longer served) | `f561eccf5c357731d9be5bc06a02accbc52e6368dd95ce95efb85542c039acc7` | 9,548,479 | [`864898cb`](https://shinjukustaition.com/proof-tools/864898cb/SHA256SUMS) | `864898cb1a7db74c54bc567307795ba154f2b8ed70e36a1336bf8c6c06c5c702` | 29 (183,830,695 bytes) |
| 2026-10-07 | `833aeed3` (no longer served) | `833aeed35eca3ad85a9b8b949b2452945a071081765677060c509fd786976ff4` | 9,602,171 | [`c777fa3e`](https://shinjukustaition.com/proof-tools/c777fa3e/SHA256SUMS) | `c777fa3eac5f874d0b8b07a4ed352ece37825412b9dfde206222f66a31a12252` | 29 (184,817,703 bytes) |
| 2026-10-07 | `cbd97cea` (no longer served) | `cbd97cea4c71cdf0b27df3b59d687cd65e4b6d93965e36a6a8f3f5a525c12c42` | 9,798,568 | [`c777fa3e`](https://shinjukustaition.com/proof-tools/c777fa3e/SHA256SUMS) | `c777fa3eac5f874d0b8b07a4ed352ece37825412b9dfde206222f66a31a12252` | 29 (184,817,703 bytes) |
| 2026-10-07 | `c0fb991f` (no longer served) | `c0fb991f0a59133c389486af11b40f0565732331152b9b8b82a84e62999d9bc3` | 9,932,761 | [`c777fa3e`](https://shinjukustaition.com/proof-tools/c777fa3e/SHA256SUMS) | `c777fa3eac5f874d0b8b07a4ed352ece37825412b9dfde206222f66a31a12252` | 29 (184,817,703 bytes) |
| 2026-10-07 | `a66228ab` (no longer served) | `a66228aba12d70e4f2cfc0fa83122bb09073bbd5734aec74a0b16ddebad044a9` | 9,937,880 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `c7abfaaf` (no longer served) | `c7abfaafb1fbcdae82adeb927b4322d79582cd45af5410f5af532141e2d74004` | 9,944,079 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `0a638498` (no longer served) | `0a6384984b20f971739f29ba3b7d1d54ff9f0861e79f330b7018812c06ba5e08` | 9,947,337 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `33d54d54` (no longer served) | `33d54d540882fdbe8d2cfaf85cfee3a34084f6de6f30a0ee7416f1996fb1f176` | 9,949,930 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `551f8ad9` (no longer served) | `551f8ad94c8a9eb17edd1322c22381e30b363d6e9478869ca92ee753162356ce` | 9,959,998 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `dc92be17` (no longer served) | `dc92be17c691b053e6a63e7b60c64d08952e56b375d8fb9010e735083d200562` | 9,994,933 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `bf2652a3` (no longer served) | `bf2652a341042f419a2dd63157bc82f354a63d01652ebb62f265540f77d71d0d` | 9,997,344 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `6909057a` (no longer served) | `6909057a6992ed86c302318cee394e8aa93bb27a7b4d006a0cf6f170939fd95c` | 10,000,534 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `c6afbdbe` (no longer served) | `c6afbdbe7e3da1d159a3f90af4ab1524a4397ca52f8d1668e5437ad10d026aaa` | 10,041,883 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `3765885f` (no longer served) | `3765885f2f9fdab66250967a4f3392708177f10c3feb7efd1f0e05cbbda39a8a` | 10,083,253 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `97d6703d` (no longer served) | `97d6703d6e3060fc07e00453022cdd800a7a67854a3be19d056c6993aed59a6b` | 10,085,139 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `721b8d65` (no longer served) | `721b8d6561911e580597559df09d3dbad0cee28b234204e1b58cc60634a464b9` | 10,086,778 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `061adadb` (no longer served) | `061adadb83970c5954fbca5a7650c7d48644df10bdeed01795bf256a59a94c71` | 10,087,516 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `b4c514cd` (no longer served) | `b4c514cdd74db9644478f804eb0f44274843916196f0be140b7788906d56ab0d` | 10,087,976 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `768001dd` (no longer served) | `768001dd1107bfa2bdcfaaffb53b791591a8b9e2c012889ce14b615a30b49ee7` | 10,098,493 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-07 | `57bfd2fd` (no longer served) | `57bfd2fd31e127d7bcfdbd11f067cb34085d23f6938be0daf3a106bd7226fb40` | 10,101,617 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-08 | `565c4f87` (no longer served) | `565c4f8710070da6e604d0fa5a25f3147ae5dc9826bbc556e51113abce8c5276` | 10,107,045 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-08 | `63316238` (no longer served) | `633162382f09c72a48eb6d1fc21a0e09a9b5e4d920da5e74ab6eb018e6dcaf85` | 10,110,248 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-08 | `b7d6f394` (no longer served) | `b7d6f394211c9d08ad158dc5e31495f31391c4dc5a9a60dc57a3773e443ba133` | 10,149,069 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-08 | `c4a50798` (no longer served) | `c4a50798e53cdde49c34a51ab16143d095278e1477eedcf0a72bc6f83ac61042` | 10,154,630 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-08 | `2c2f9874` (no longer served) | `2c2f9874f95619ef291f89fa88158b97d2125198a12abe8ecade9d6c2e9f10fc` | 10,175,816 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-08 | `1a336885` (no longer served) | `1a3368854f4bdfe185a2ac398106c9b39a7148225f1a3ec6a6dcead563c7ed53` | 10,176,434 | [`82b2d870`](https://shinjukustaition.com/proof-tools/82b2d870/SHA256SUMS) | `82b2d8709f28cfdd65c9a03707af4811b8d6e77b1231b4e1de6dd2d84f209c3b` | 26 (144,319,243 bytes) |
| 2026-10-08 | `11fe6b40` (no longer served) | `11fe6b40661d3af5e7fe50a20603a1efde4d0997fc243fb16709daad94fd8d29` | 10,289,404 | [`24e819a8`](https://shinjukustaition.com/proof-tools/24e819a8/SHA256SUMS) | `24e819a86928a3da7b2f0d297237f6411129cc0cccffbc77d92461022e617da0` | 26 (144,322,131 bytes) |
| 2026-10-08 | `94a357bc` (no longer works: pool program upgraded) | `94a357bc22e57592fde37c3a98a4a79a79d031ea5f1ab90261d2f25d7ad85aec` | 10,438,545 | [`262e1e98`](https://shinjukustaition.com/proof-tools/262e1e98/SHA256SUMS) | `262e1e98f871a12dbd7f3d6a41350982a098109e7e7356e44e854b96dac73f24` | 26 (144,322,131 bytes) |
| 2026-10-08 | `a8516e49` (no longer works: pool program upgraded) | `a8516e499a99fb8c0157cbdf5321ed3e9352d4511707b5ccc39e12277771c529` | 10,438,942 | [`262e1e98`](https://shinjukustaition.com/proof-tools/262e1e98/SHA256SUMS) | `262e1e98f871a12dbd7f3d6a41350982a098109e7e7356e44e854b96dac73f24` | 26 (144,322,131 bytes) |
| 2026-10-08 | `d2a7291f` (no longer works: pool program upgraded) | `d2a7291f11d583fab55b39ab67cc820808e5c7607618d1456c70cda34eb3450f` | 10,441,804 | [`262e1e98`](https://shinjukustaition.com/proof-tools/262e1e98/SHA256SUMS) | `262e1e98f871a12dbd7f3d6a41350982a098109e7e7356e44e854b96dac73f24` | 26 (144,322,131 bytes) |
| 2026-10-09 | `36d0219d` (no longer works: stale proof-tools pin) | `36d0219d0ccb169ff0dc6d81d60a0437c10e7c26d9878fe673d86cc4043fb581` | 10,759,010 | [`a9f18f88`](https://shinjukustaition.com/proof-tools/a9f18f88/SHA256SUMS) | `a9f18f88d1999f50f1c589ec80c746fda634262c7051a5e7d76c534fe9431db8` | 26 (144,324,423 bytes) |
| 2026-10-09 | `14dd9efa` (no longer works: pool AAG16 retired) | `14dd9efa7c6bbd2906a56e732a4aff9d23c7b867b6fd9fec4f005494acc3823b` | 10,759,068 | [`9975fdf8`](https://shinjukustaition.com/proof-tools/9975fdf8/SHA256SUMS) | `9975fdf857298f5fcb82feba64400b21faca0bad846c61e9126b9a0663d430be` | 26 (144,324,423 bytes) |
| 2026-10-10 | `f2ea6840` (no longer served) | `f2ea684051a96e03ea86d998ad5b2f4033de55fce3a4f9695376e611884fdbc6` | 10,788,620 | [`ad860e62`](https://shinjukustaition.com/proof-tools/ad860e62/SHA256SUMS) | `ad860e62dd9bde09008fce798dbe0970f59ef9f7fca846e5a5238c93d7f42597` | 26 (144,319,242 bytes) |
| 2026-10-11 | `e3348092` (no longer served) | `e3348092deb29664a3496827f72bdd6dafc9f5f67f41b463da4c2bc84432cfac` | 10,846,173 | [`ad860e62`](https://shinjukustaition.com/proof-tools/ad860e62/SHA256SUMS) | `ad860e62dd9bde09008fce798dbe0970f59ef9f7fca846e5a5238c93d7f42597` | 26 (144,319,242 bytes) |
| 2026-10-11 | `9f9b4039` (no longer served) | `9f9b4039a044f74189b8a1a932c489c9653c1cdd3609d6b062363ced61ca30c6` | 10,814,984 | [`ad860e62`](https://shinjukustaition.com/proof-tools/ad860e62/SHA256SUMS) | `ad860e62dd9bde09008fce798dbe0970f59ef9f7fca846e5a5238c93d7f42597` | 26 (144,319,242 bytes) |
| 2026-10-11 | `488372b4` (no longer works: stale program pin) | `488372b4f12886748870eb5fb6d5f25eb42a43b6ddc6f74c20cac033fe5f6927` | 10,818,483 | [`ad860e62`](https://shinjukustaition.com/proof-tools/ad860e62/SHA256SUMS) | `ad860e62dd9bde09008fce798dbe0970f59ef9f7fca846e5a5238c93d7f42597` | 26 (144,319,242 bytes) |
| 2026-10-11 | `19542942` (no longer served) | `195429425616ad43e2e4bbb61e31da7b25bd74b30301b28ae4f4aa18a08250b1` | 10,818,483 | [`47678912`](https://shinjukustaition.com/proof-tools/47678912/SHA256SUMS) | `47678912949d7da8b705c399edf03d2367465f6eb581b00a059356373baed28e` | 26 (144,322,174 bytes) |
| 2026-10-11 | `394d020a` (no longer served) | `394d020a4183ea7ff50282001e5f37cd5d5602822ef468df72569a0c3292061e` | 10,819,973 | [`47678912`](https://shinjukustaition.com/proof-tools/47678912/SHA256SUMS) | `47678912949d7da8b705c399edf03d2367465f6eb581b00a059356373baed28e` | 26 (144,322,174 bytes) |
| 2026-10-11 | [`08a4b56f`](https://shinjukustaition.com/wallet/08a4b56f/shinjuku-wallet.mjs) | `08a4b56f6452268ffdd513e67326de8782b53dcec16ba88adaddf16793581206` | 10,822,047 | [`47678912`](https://shinjukustaition.com/proof-tools/47678912/SHA256SUMS) | `47678912949d7da8b705c399edf03d2367465f6eb581b00a059356373baed28e` | 26 (144,322,174 bytes) |
| 2026-10-12 | [`701809bd`](https://shinjukustaition.com/wallet/701809bd/shinjuku-wallet.mjs) | `701809bdf80ea16a9d16105f067998029d2a0f03d69b885720a08d806eae30d4` | 10,943,907 | [`47678912`](https://shinjukustaition.com/proof-tools/47678912/SHA256SUMS) | `47678912949d7da8b705c399edf03d2367465f6eb581b00a059356373baed28e` | 26 (144,322,174 bytes) |
| 2026-10-12 | [`28f33853`](https://shinjukustaition.com/wallet/28f33853/shinjuku-wallet.mjs) | `28f33853062c9982283f59bef13a6bb33b6ce474ea62c0d30ae6e0d473e66da2` | 10,945,718 | [`5bed238f`](https://shinjukustaition.com/proof-tools/5bed238f/SHA256SUMS) | `5bed238f3696208ca3a8e66d206e5fffc85f1823e959abe1901c2d57c17bcdf3` | 26 (144,319,242 bytes) |
| 2026-10-12 | [`a9b9ea19`](https://shinjukustaition.com/wallet/a9b9ea19/shinjuku-wallet.mjs) | `a9b9ea19ca82a7e4fe991f01050aae148bea45db0bb46be31c22df310e081969` | 10,949,292 | [`5bed238f`](https://shinjukustaition.com/proof-tools/5bed238f/SHA256SUMS) | `5bed238f3696208ca3a8e66d206e5fffc85f1823e959abe1901c2d57c17bcdf3` | 26 (144,319,242 bytes) |
| 2026-10-13 | [`d769dad3`](https://shinjukustaition.com/wallet/d769dad3/shinjuku-wallet.mjs) | `d769dad321e1a1f88e0557c65b56336b2d6356fbd0167bc0f4acbed55793b27a` | 11,120,051 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-13 | [`d2ba7e62`](https://shinjukustaition.com/wallet/d2ba7e62/shinjuku-wallet.mjs) | `d2ba7e62eff143df57466d5f0ba534856e29c88007eafc22c3dfaeb89535eadb` | 11,120,794 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-13 | [`db079e37`](https://shinjukustaition.com/wallet/db079e37/shinjuku-wallet.mjs) | `db079e3700b17388873252fb91358d1918801ff69d1ee26f4e3e9f21bccbab34` | 11,121,670 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-13 | [`6a87b0a1`](https://shinjukustaition.com/wallet/6a87b0a1/shinjuku-wallet.mjs) | `6a87b0a15ec5979313adc3e9b7f19e239c2f14af1c46565e958054dbc60e8af7` | 11,122,024 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-13 | [`b32bffc7`](https://shinjukustaition.com/wallet/b32bffc7/shinjuku-wallet.mjs) | `b32bffc727e1e7e33fb134a3918638006259033511e1a2aaf455d037da1f70b3` | 11,124,201 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-13 | [`2ec5cd82`](https://shinjukustaition.com/wallet/2ec5cd82/shinjuku-wallet.mjs) | `2ec5cd82c2ae8b9008491d07b5dc4740a5db5904e92814870fd66080aec7fc7b` | 11,113,178 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-13 | [`6adb4430`](https://shinjukustaition.com/wallet/6adb4430/shinjuku-wallet.mjs) | `6adb44302a8db0b19245a1366e56090c0f0d27c443f37e69c1c2ef97151c9e74` | 11,115,097 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-14 | [`8b897dc9`](https://shinjukustaition.com/wallet/8b897dc9/shinjuku-wallet.mjs) | `8b897dc95ce8c17c9b0730c6ca5fddaf727b315d054489154d30bd795692a390` | 11,127,328 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-14 | [`c1963de1`](https://shinjukustaition.com/wallet/c1963de1/shinjuku-wallet.mjs) | `c1963de19cc61973bc35d2d55284b771db5846c323419f771e342f9cd3052e57` | 11,128,106 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-14 | [`79f40d94`](https://shinjukustaition.com/wallet/79f40d94/shinjuku-wallet.mjs) | `79f40d948e80ecdbe29b67d336b971ecc50c3f6b220349e0915ff7d8cae7178d` | 11,130,649 | [`5fa83692`](https://shinjukustaition.com/proof-tools/5fa83692/SHA256SUMS) | `5fa8369234088b532977254d91109e7eced3aef0228b9ed55c7c8a02e0a9a908` | 26 (144,322,314 bytes) |
| 2026-10-14 | [`00da3f6d`](https://shinjukustaition.com/wallet/00da3f6d/shinjuku-wallet.mjs) | `00da3f6dfb766d83cd9f1fdb8c3a335c2de51a5dbab0d13b0e6ce3d50106cf02` | 11,131,156 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-14 | [`10c8bdfe`](https://shinjukustaition.com/wallet/10c8bdfe/shinjuku-wallet.mjs) | `10c8bdfe8bd677ce6f50d143c1af4b28d5b3f653c5c65f6356f1034e6f5840df` | 11,132,902 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-14 | [`5e07378e`](https://shinjukustaition.com/wallet/5e07378e/shinjuku-wallet.mjs) | `5e07378e3416f54223cbb56fc04d28bed3106dfbdef58b62570ad0469f27aade` | 11,135,322 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-14 | [`1505ebf0`](https://shinjukustaition.com/wallet/1505ebf0/shinjuku-wallet.mjs) | `1505ebf0afdb67fbbe6050d5065335f3b13e94cefd356fb422ce946f4fba3253` | 11,138,284 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`f2dc55fb`](https://shinjukustaition.com/wallet/f2dc55fb/shinjuku-wallet.mjs) | `f2dc55fb5d552bef98fe2d530d37c301045501d0f750a2c9a17ddf63b1a934f3` | 11,150,739 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`adb0f68b`](https://shinjukustaition.com/wallet/adb0f68b/shinjuku-wallet.mjs) | `adb0f68b23e192445ecb391a89f3e05dba89f05d0177aacdb092fbea3539fa85` | 11,154,518 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`dd6ce54a`](https://shinjukustaition.com/wallet/dd6ce54a/shinjuku-wallet.mjs) | `dd6ce54a50e0e58be863f647620b767cb760d1278ee089b74c10c98068383047` | 11,159,107 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`902397c7`](https://shinjukustaition.com/wallet/902397c7/shinjuku-wallet.mjs) | `902397c7c00f815b7f80b1275a1a987ca78871df5fdf370e7c80a282ecfb15a4` | 11,176,401 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`a523d67b`](https://shinjukustaition.com/wallet/a523d67b/shinjuku-wallet.mjs) | `a523d67b85ebcfd6f07f653c2a9bde16a7c9d87f908874ddae71cf91083fabc8` | 11,177,579 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`c8c82dc4`](https://shinjukustaition.com/wallet/c8c82dc4/shinjuku-wallet.mjs) | `c8c82dc4ce0277f8c560adec5cb16119709d00240a8efa4ebbb2a426e5161b6a` | 11,178,235 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`3ec79a83`](https://shinjukustaition.com/wallet/3ec79a83/shinjuku-wallet.mjs) | `3ec79a8335ea99f87cf8f2c34ea8723c70a30bd6f30fc5c0fb177edfa1816714` | 11,184,498 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`dae9ba88`](https://shinjukustaition.com/wallet/dae9ba88/shinjuku-wallet.mjs) | `dae9ba8800e48179602d5595c5bbc71029a758be726e72482d24a52126649ac9` | 11,184,999 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`b22ae0f7`](https://shinjukustaition.com/wallet/b22ae0f7/shinjuku-wallet.mjs) | `b22ae0f772097b698eba694cfec8b31061921a38948c11702df3653881361e9f` | 11,185,132 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`fc7329d0`](https://shinjukustaition.com/wallet/fc7329d0/shinjuku-wallet.mjs) | `fc7329d0267d82e7f06546009c64924d0ec713165c3bfe270512ba0672b94cbd` | 11,187,416 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`65889774`](https://shinjukustaition.com/wallet/65889774/shinjuku-wallet.mjs) | `658897741c5d9bce482ff9d932f4ade7e51cf98f834e78c3f693da1e1771e547` | 11,193,868 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`1335e815`](https://shinjukustaition.com/wallet/1335e815/shinjuku-wallet.mjs) | `1335e815f99108526e1a9d4e93f53a94d95910ea150e404987f09826c39fc547` | 11,195,840 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`a7255985`](https://shinjukustaition.com/wallet/a7255985/shinjuku-wallet.mjs) | `a72559850e57ae647a20df449f9f47be5d359e1cf1debda30ded104225bdacb5` | 11,212,421 | [`78c71143`](https://shinjukustaition.com/proof-tools/78c71143/SHA256SUMS) | `78c71143ecedf22096fdc1901eda5160e29c141f6961cce935b92e714ff85bd9` | 30 (191,014,041 bytes) |
| 2026-10-15 | [`5f5ca189`](https://shinjukustaition.com/wallet/5f5ca189/shinjuku-wallet.mjs) | `5f5ca189829786779ba9e05c237bb6edf057a06d4745f0a601212136aa0bf68f` | 11,216,201 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`5b21a788`](https://shinjukustaition.com/wallet/5b21a788/shinjuku-wallet.mjs) | `5b21a788efa0e47f3e83f413f73a4c11a70f068edda47f4f68be3bd6c0855955` | 11,226,333 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`387938b4`](https://shinjukustaition.com/wallet/387938b4/shinjuku-wallet.mjs) | `387938b415cfece575952e875ecafc7149e29279e202a4e862433f66f664a803` | 11,230,018 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`f55f1fb8`](https://shinjukustaition.com/wallet/f55f1fb8/shinjuku-wallet.mjs) | `f55f1fb8f1b63bf4caf94b552f06f6c3126ed8fd598d6d8fe8fc9abd7377b509` | 11,232,354 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`0ff1dea5`](https://shinjukustaition.com/wallet/0ff1dea5/shinjuku-wallet.mjs) | `0ff1dea585d7a2ca69e0a37f43684dcb411f5a28eafa84a3f7fee65f5cd13904` | 11,235,804 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`99e5ce60`](https://shinjukustaition.com/wallet/99e5ce60/shinjuku-wallet.mjs) | `99e5ce600a930373051d72e16b2fe75bec451cfbdd509439e58546d0e77058d2` | 11,247,206 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`54ae7e65`](https://shinjukustaition.com/wallet/54ae7e65/shinjuku-wallet.mjs) | `54ae7e6525d0c2a5330f3243891a2cbc5d728a4bcea81a61ba3aaf065bed8b63` | 11,266,570 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`fe90fa0a`](https://shinjukustaition.com/wallet/fe90fa0a/shinjuku-wallet.mjs) | `fe90fa0a418682c08b49b05bcda64ffd7b6cf8803166f95968205c80a2fcab4b` | 11,282,021 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`efd1a80d`](https://shinjukustaition.com/wallet/efd1a80d/shinjuku-wallet.mjs) | `efd1a80db30f354b1fd326c9619666b7d63ce4051428a5e7a4f267a04ca568ea` | 11,284,496 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`8d1268b7`](https://shinjukustaition.com/wallet/8d1268b7/shinjuku-wallet.mjs) | `8d1268b754e192e52be5ba3d5cf134ed42eee552605d96c11076a6004204c737` | 11,402,568 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-16 | [`4baf3bca`](https://shinjukustaition.com/wallet/4baf3bca/shinjuku-wallet.mjs) | `4baf3bca327b51694452760cdb6a4f65d8e869a4c64040c832e92937f66ab395` | 11,416,627 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-18 | [`491c1f01`](https://shinjukustaition.com/wallet/491c1f01/shinjuku-wallet.mjs) | `491c1f0186d39c718fba9a7e275a88a72752a90a63fab845ae8844abfbf38694` | 11,537,195 | [`8d8db6a0`](https://shinjukustaition.com/proof-tools/8d8db6a0/SHA256SUMS) | `8d8db6a0ef847031d01a2b65608e4b456c231c0d348f893e01eba4ad908907f3` | 30 (191,017,113 bytes) |
| 2026-10-18 | [`22fd74c5`](https://shinjukustaition.com/wallet/22fd74c5/shinjuku-wallet.mjs) | `22fd74c53ae9aa03fb33a848794e41f62e92c1d20e95697cc9d3233ca76c2432` | 11,593,541 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-19 | [`dfff2182`](https://shinjukustaition.com/wallet/dfff2182/shinjuku-wallet.mjs) | `dfff21825cc4452582636aa8ccf6fe96823b1f335bdb0514c723f9a5ae6f02dd` | 11,614,411 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-20 | [`667ac38b`](https://shinjukustaition.com/wallet/667ac38b/shinjuku-wallet.mjs) | `667ac38b9b42b60853ea07024e81b1074105b3dbfba4346d61d86ef3aabef1b3` | 11,939,765 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-21 | [`285d2c1d`](https://shinjukustaition.com/wallet/285d2c1d/shinjuku-wallet.mjs) | `285d2c1db3cfd9d8a5df47acc2c70e7e65816539c3f2ad216ede6a16358d762b` | 12,117,554 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-21 | [`70ff655b`](https://shinjukustaition.com/wallet/70ff655b/shinjuku-wallet.mjs) | `70ff655b113c19d39c8594566c77d38fe7d459ea415f66cda1c09919841ad1a9` | 12,128,720 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-21 | [`e18d1d95`](https://shinjukustaition.com/wallet/e18d1d95/shinjuku-wallet.mjs) | `e18d1d9537ea063f2a28f88b4db41a1b93067c5d5aa4f300daaddf80d8544074` | 12,133,623 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`a5a9b7dd`](https://shinjukustaition.com/wallet/a5a9b7dd/shinjuku-wallet.mjs) | `a5a9b7ddd7aa96aa7feb6470868cd662c20f0f412df665093e768c07c4cda23c` | 12,153,017 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`780f6896`](https://shinjukustaition.com/wallet/780f6896/shinjuku-wallet.mjs) | `780f6896d6051a0d49b5a716d0ed36d9ea1487342f5582b7f2bc1c91280342e7` | 12,157,954 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`a18f4dcc`](https://shinjukustaition.com/wallet/a18f4dcc/shinjuku-wallet.mjs) | `a18f4dcc8553e48c173aa610e7b3632d8edb25dbe317dd1f820e44673dd0fa39` | 12,158,087 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`ad143a47`](https://shinjukustaition.com/wallet/ad143a47/shinjuku-wallet.mjs) | `ad143a47257fa8b5e147ba3f6b662576794b06184abbedce42fd4f74993d9b7e` | 12,161,659 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`fd8f40cf`](https://shinjukustaition.com/wallet/fd8f40cf/shinjuku-wallet.mjs) | `fd8f40cfc0110953e30d8479bfe751545e04952df8faf03b634073d7fd308c78` | 12,166,389 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`d9319f9c`](https://shinjukustaition.com/wallet/d9319f9c/shinjuku-wallet.mjs) | `d9319f9cc0d4e5deebfa15e1ac35bee0bc4f4ffb95cd4f58e400ee322ac11076` | 12,167,009 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`f3c65200`](https://shinjukustaition.com/wallet/f3c65200/shinjuku-wallet.mjs) | `f3c652001435e22d3e54232fe742166dd8dd5ae183b92c1a24274c7a52ed137c` | 12,174,893 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`f7b2fe09`](https://shinjukustaition.com/wallet/f7b2fe09/shinjuku-wallet.mjs) | `f7b2fe093da4904a611ef95fb52e7888ad1f23b2f41681474d1bd9bef75a71f8` | 12,179,295 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`f1563e53`](https://shinjukustaition.com/wallet/f1563e53/shinjuku-wallet.mjs) | `f1563e53fc8d137fe44e6fb65d7247fa157b3066b7129b41ef9f99d2e3061ba7` | 12,180,292 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`402e7c36`](https://shinjukustaition.com/wallet/402e7c36/shinjuku-wallet.mjs) | `402e7c3666bf4dfe147de8229872bdf611540526a15d5fdb690392c81b878b9d` | 12,181,283 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`4d9b6de2`](https://shinjukustaition.com/wallet/4d9b6de2/shinjuku-wallet.mjs) | `4d9b6de27c68f9fb53c414d063679fde5a62eb26a2a46f13bebfde9a4d74b042` | 12,186,827 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`3d64f9b4`](https://shinjukustaition.com/wallet/3d64f9b4/shinjuku-wallet.mjs) | `3d64f9b47b1139c42d3a2ff22642951710beeb669bf633b934b31419e94cc843` | 12,187,129 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`c6cbe0a6`](https://shinjukustaition.com/wallet/c6cbe0a6/shinjuku-wallet.mjs) | `c6cbe0a61037f0a435f7ce448d6ff6fc6a4a97a9b7336fea33c9e7a1e56c11e7` | 12,194,855 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`ae568c80`](https://shinjukustaition.com/wallet/ae568c80/shinjuku-wallet.mjs) | `ae568c800e9c2e6ccaf4cad6958cf133aa07469a93428827e679d3a1be89505f` | 12,197,454 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`61674c4e`](https://shinjukustaition.com/wallet/61674c4e/shinjuku-wallet.mjs) | `61674c4e8c6309ae6c93338211bf57a674837f572e498215300031a65b9aa743` | 12,200,396 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`07990722`](https://shinjukustaition.com/wallet/07990722/shinjuku-wallet.mjs) | `07990722e8c34815b7af576fe293f456c602895b74cbe6f75d5ea3d8b5a1d578` | 12,201,104 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`ff6f25bc`](https://shinjukustaition.com/wallet/ff6f25bc/shinjuku-wallet.mjs) | `ff6f25bccfd2a50929a8dc82137b4fb42172790f9d71a6c07f166bda3e052d22` | 12,210,958 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-22 | [`bf5ad0c1`](https://shinjukustaition.com/wallet/bf5ad0c1/shinjuku-wallet.mjs) | `bf5ad0c16095110ed0258b16525e55dc743dbaa36b6ba0e0738d4ab9c185ce90` | 12,226,842 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 | [`57e0bc6a`](https://shinjukustaition.com/wallet/57e0bc6a/shinjuku-wallet.mjs) | `57e0bc6a687a2bfdd99fe9ff69834c53f842829dac245c756dc02a49cc1bd0fa` | 12,235,821 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 | [`6d58045e`](https://shinjukustaition.com/wallet/6d58045e/shinjuku-wallet.mjs) | `6d58045e00745225ce82558f7a464bd8ad3379915ac3d909a4cd1c9a2ab7c84c` | 12,243,658 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 | [`e2b3bd72`](https://shinjukustaition.com/wallet/e2b3bd72/shinjuku-wallet.mjs) | `e2b3bd72ce01876258900e8683258e3d1606c598f9757c882fe49f57ac2868e5` | 12,248,891 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 | [`b840ab22`](https://shinjukustaition.com/wallet/b840ab22/shinjuku-wallet.mjs) | `b840ab22b761c3a08caa1fc73f7e9d0b4ae0139a21aeca10fdf71086a0092704` | 12,282,953 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 | [`2b67ac65`](https://shinjukustaition.com/wallet/2b67ac65/shinjuku-wallet.mjs) | `2b67ac65c0b0dbe5bb41d3c393c8c44970fdd9c43e7e84a96c6a9e373ad5c957` | 12,294,189 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 | [`98296ff0`](https://shinjukustaition.com/wallet/98296ff0/shinjuku-wallet.mjs) | `98296ff0ef88ddfa494d9e1f46963a55563d92b1ec6fc29cfc1b0f18debe81e0` | 12,313,625 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 (candidate, npm `next`) | [`63f08b62`](https://shinjukustaition.com/wallet/63f08b62/shinjuku-wallet.mjs) | `63f08b6256e8f9d53e9d4e2f24be3ac56580e8cb82d64517a8326e6749eaa928` | 12,448,432 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 (candidate, npm `next`) | [`eaf7063e`](https://shinjukustaition.com/wallet/eaf7063e/shinjuku-wallet.mjs) | `eaf7063ed1fe0dbcbf1c1f689e1ce60018401d669fe8bad7a7d4483cb875da0a` | 12,477,292 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 (candidate, npm `next`) | [`a59aa27b`](https://shinjukustaition.com/wallet/a59aa27b/shinjuku-wallet.mjs) | `a59aa27b98cd1822c4651ed0567cd35b3f03e087818d8e5cfdb71e6320b7ffae` | 12,484,127 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 (candidate, npm `next`) | [`b73f57e5`](https://shinjukustaition.com/wallet/b73f57e5/shinjuku-wallet.mjs) | `b73f57e58ae0466a090f5b1728e7852bab48e7d28ad6bb0f0ba9657b6cc681b1` | 12,505,075 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 (candidate, npm `next`) | [`654041bc`](https://shinjukustaition.com/wallet/654041bc/shinjuku-wallet.mjs) | `654041bce4139bfb928180cc1a3c1ff05e570d9fc51ddfa718e9d0ef7fbf9095` | 12,513,236 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 (stable, pinned) | [`b650bf06`](https://shinjukustaition.com/wallet/b650bf06/shinjuku-wallet.mjs) | `b650bf0682830e05207f52bad2ba426ec7f8fa1bbbfdb7e028057865e3d83d24` | 12,522,998 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 (candidate, npm `next`) | [`c0b0b77b`](https://shinjukustaition.com/wallet/c0b0b77b/shinjuku-wallet.mjs) | `c0b0b77bafa0cc4e15bd9c01e207c73b8188102f8ed1c9fe5e74e67c7bde008b` | 12,523,149 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-23 (candidate, npm `next`) | [`17d8275d`](https://shinjukustaition.com/wallet/17d8275d/shinjuku-wallet.mjs) | `17d8275d7939ba1783b53b5839277d88fdb473fd4e1cfb1e59e6f0226e13d8fb` | 12,524,840 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`9af59797`](https://shinjukustaition.com/wallet/9af59797/shinjuku-wallet.mjs) | `9af59797297cdea3750a86cc8bc6287cab8952e4a8fc5da4bdb8d3e48ab2bd67` | 12,528,864 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`4cda1792`](https://shinjukustaition.com/wallet/4cda1792/shinjuku-wallet.mjs) | `4cda1792a58d926b79cdd34975b53b9177940b1f3e266318695cb32d7f70b295` | 12,682,087 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`1d784246`](https://shinjukustaition.com/wallet/1d784246/shinjuku-wallet.mjs) | `1d7842469a3a56390eae2b339649cb42551a19ef63c2f9b1d5716f875ce11b52` | 12,694,423 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`afa037c8`](https://shinjukustaition.com/wallet/afa037c8/shinjuku-wallet.mjs) | `afa037c8868c722838c0642335b1767af4bcc0040878ae441e83cb94dd9aeea2` | 12,692,822 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`6048ca61`](https://shinjukustaition.com/wallet/6048ca61/shinjuku-wallet.mjs) | `6048ca6123de12e425ab2f3575fa69838eb1ea93dbff3d2facab612e0004bf8a` | 12,704,961 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`af5b54d5`](https://shinjukustaition.com/wallet/af5b54d5/shinjuku-wallet.mjs) | `af5b54d5bce11c64a002dca7d59c8593767ddefe4b7177b8ef44cdefb27f0030` | 12,706,861 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`6304f680`](https://shinjukustaition.com/wallet/6304f680/shinjuku-wallet.mjs) | `6304f68098886ee10121039f4fb06e7b07fc812b608c5595292ffeaad1ff2ea9` | 12,720,423 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`4a3321b0`](https://shinjukustaition.com/wallet/4a3321b0/shinjuku-wallet.mjs) | `4a3321b081e721e8815c614b5e68bb8bf31405cda64ff0b1b9f3b98e62958bab` | 12,723,643 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`7438f0e3`](https://shinjukustaition.com/wallet/7438f0e3/shinjuku-wallet.mjs) | `7438f0e355051a345b05c050dcc5f2aac8a676e3972b1cf195cc48bb41883790` | 12,750,584 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`1fe3c2f7`](https://shinjukustaition.com/wallet/1fe3c2f7/shinjuku-wallet.mjs) | `1fe3c2f76f93108cbe16d3ca665e14e298d03ec14f081a9660f82e114011e87d` | 12,772,279 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`5023a291`](https://shinjukustaition.com/wallet/5023a291/shinjuku-wallet.mjs) | `5023a2917ba9f9f802a955c0782826c061664754b9b463c59aca590154c1539e` | 12,786,716 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`fe6cb068`](https://shinjukustaition.com/wallet/fe6cb068/shinjuku-wallet.mjs) | `fe6cb068e76316bd9c4fab329dbd3586d980d69f6fe42a0f01fa1a254abb4410` | 12,791,175 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`1c3d204e`](https://shinjukustaition.com/wallet/1c3d204e/shinjuku-wallet.mjs) | `1c3d204e7ba114b9d80654035efb4a244ac607f038e1961f23663b7af9b45dc5` | 12,794,106 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |
| 2026-10-24 (candidate, npm `next`) | [`3a984162`](https://shinjukustaition.com/wallet/3a984162/shinjuku-wallet.mjs) | `3a9841626e4a97d756f610278b4e03f2571b556a7b06207c418a850b2b5200bf` | 12,797,194 | [`a9af32df`](https://shinjukustaition.com/proof-tools/a9af32df/SHA256SUMS) | `a9af32df6b7ff7e3243bd607b7ff582da5732fa422f28afd9b8bc3e9f0d6c741` | 30 (191,112,305 bytes) |

Beside each wallet file, the website also serves `LICENSE.txt` (the
copyright notice), `THIRD_PARTY_NOTICES.txt` (the open-source licenses inside
the file), and `manifest.json` (the source commit and every bundled package).
The manifest's source commit names our private development repository. This
public repository publishes the hashes, not the source code. Every release is
reproducible: two independent builds (Windows and Linux) of that commit give
the same SHA-256, and our server refuses to start if the file it serves differs
from the pinned hash.

## Get the wallet

The wallet needs Node.js 22.21 or later (or Node.js 24 or later) and nothing
else. The stable release is `b650bf06`: put it in place of `<sha8>` below.

### 1. Download

```sh
curl -fsSLO https://shinjukustaition.com/wallet/<sha8>/shinjuku-wallet.mjs
```

On Windows, type `curl.exe`, not `curl` (in Windows PowerShell, `curl` is a
different command).

Over Tor, from our onion service (production):

```sh
curl --socks5-hostname 127.0.0.1:9050 -fsSLO \
  http://2kfhlfuyuwvhmibjrpxqsg4nrbcxasjgjq7kmnfzgfwzptkhhznz3dad.onion/wallet/<sha8>/shinjuku-wallet.mjs
```

### 2. Check the SHA-256

Compare the file with the hash in the Releases table above. Go on only when the check
prints `OK`. On any other result, delete the file and do not run it.

Linux:

```sh
echo "<sha256>  shinjuku-wallet.mjs" | sha256sum -c -
```

macOS:

```sh
echo "<sha256>  shinjuku-wallet.mjs" | shasum -a 256 -c -
```

Windows (PowerShell):

```powershell
if ((Get-FileHash .\shinjuku-wallet.mjs -Algorithm SHA256).Hash -eq "<sha256>") { "OK" } else { "MISMATCH" }
```

Windows (cmd.exe): `certutil -hashfile shinjuku-wallet.mjs SHA256` prints
the hash. It must equal the SHA-256 in the table.

A match proves that your copy is complete and equals the file whose hash we
published here. It does not prove who made the file.

### 3. Read the help

```sh
node shinjuku-wallet.mjs help
node shinjuku-wallet.mjs help init
```

`help <command>` prints a working example, every flag, and the next step.
Exit code 0 means done. Exit code 1 means the command ran and failed (one
line says why). Exit code 2 means the command line is wrong (it shows a
working example).

With the wallet file alone, these commands work: every `help` page, `init`,
`backup-export`, `backup-verify`, `restore`, `balance` (without
`--refresh`), and `limits`. The money commands also need
the proof tools (next section).

## Get the proof tools

`add-funds`, `deposit`, `recover`, `balance --refresh`, `pay`, `buy-item`,
`unshield`, and `pocket reshield` need the proof tools of the
facilitator that you use: two manifests, the facilitator's public profile,
Linux x86-64 provers, and the signed proving parameters (30 files, about
191 MB, for proof tools `a9af32df`).

The provers are Linux programs.

- **Linux:** run the steps below as written.
- **Windows:** install WSL (Ubuntu). Run the steps in a WSL shell, in a folder
  on a Windows drive (for example `/mnt/c/Users/<you>/shinjuku-proof-tools`).
  Then run the wallet from Windows with the `C:\` paths. The wallet runs each
  prover through `wsl.exe`.
- **macOS:** not supported. Use a Linux machine or a Linux container.

```sh
mkdir shinjuku-proof-tools && cd shinjuku-proof-tools
base=https://shinjukustaition.com/proof-tools/<sha8>
curl -fsSO "$base/SHA256SUMS"
echo "<sha256 of the file list>  SHA256SUMS" | sha256sum -c -
while read -r sum path; do mkdir -p "$(dirname "$path")"; curl -fsS -o "$path" "$base/$path"; done < SHA256SUMS
sha256sum -c --strict --quiet SHA256SUMS && echo ALL_OK
chmod +x bin/* house/bin/* bundle/bin/*
```

Go on only when the list check prints `OK` and the last check prints
`ALL_OK`. Then give the wallet:

- `--proof-tools shinjuku-proof-tools/proof-tools.json`
  (`--payer-proof-tools` for `unshield`),
- `--exit-proof-tools shinjuku-proof-tools/exit-proof-tools.json`,
- `--profile shinjuku-proof-tools/public-profile.json`.

The wallet checks the SHA-256 of each binary again before every run.

## Quick start

The full guide is the wallet's own help. The steps below follow it.

### What you need

- Node.js 22.21 or later, or Node.js 24 or later. (The two `privacy-cash` commands need Node.js 24 and
  the Privacy Cash SDK, which the wallet file does not include.)
- The proof tools (previous section).
- A Solana RPC URL in a private file, `rpc.txt`. With `--tor`, use an RPC
  URL that has no API key in it: a keyed URL names its owner.
- A private folder for the wallet, and a passphrase of 8 or more characters.
- The public identities (program, pool, mint, network, facilitator): run
  `node shinjuku-wallet.mjs help`. Each release names its own facilitator.

```sh
export SHIELDED_WALLET_HOME=<a private folder>
export SHIELDED_WALLET_PASSPHRASE=<your passphrase>
W=shinjuku-wallet.mjs
```

Keep the same passphrase in `passphrase.txt` and your RPC URL in `rpc.txt`.

### Hide your IP

Add `--tor` to any command. Start Tor with one line in `torrc`:
`HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr`. The wallet checks that it
reaches the network through Tor before it sends any other request, and it
refuses any connection that does not go through the proxy.

### 1. Create the wallet

```sh
node $W init --pool $POOL --network $NETWORK --asset $MINT \
  --binding carbon-shielded-exact/svm-v3 --backup-out recovery.txt
```

Caps are optional: by default there is no limit, and only the balance bounds
a payment. `init --max-payment` and `--max-cumulative` set caps in the
wallet file. `limits` shows them, and changes or removes them later
(`none` removes a cap):

```sh
node $W limits --pool $POOL
node $W limits --pool $POOL --max-payment none --max-cumulative none
```

`init` writes your recovery text (the seed and the Solana secret key) only
to the new `--backup-out` file, never to the screen. Copy that file to two
offline places, then delete it from this machine. Keep the
`solanaFeePayer` and `seedFingerprint` that `init` prints beside it.

### 2. Back up (after every step that moves value)

```sh
node $W backup-export --pool $POOL --to /backups/01-created
node $W backup-verify --pool $POOL --backup-dir /backups/01-created
```

### 3. Add funds privately

```sh
node $W help add-funds
```

`add-funds` runs every funding step in order and waits between them. It ends
with `ready` and your balance. Three routes:

- `exchange`: withdraw the exact amount from an exchange to the one-time
  address that the wallet prints. The exchange knows you, the amount, and
  the address.
- `changenow`: a fixed-rate ChangeNOW swap to the one-time address, paid
  with Monero (best), BTC, or ETH. ChangeNOW sees the amount and the
  address.
- `privacy-cash`: your own wallet pays into the Privacy Cash pool; at least
  24 hours and 10 other deposits later, Privacy Cash pays the one-time
  address. It takes about a day.

Never fund the one-time address from a wallet that you use elsewhere. That
transfer links you.

### 4. Pay

```sh
node $W help pay
```

- A seller whose 402 offers `shielded-exact`: `pay` pays it from your
  shielded balance at the seller's price.
- Any other Solana x402 `exact` endpoint that takes USDC: `pay` pays it
  through Shinjuku (float pay). Your wallet pays us privately, price plus
  the fee, and we pay the seller from our float. `--maximum-atomic` must
  cover price plus fee. Nothing to fill or set up.
- A rerun with the same `--request-id` never pays twice.

A balance that came in by several deposits (for example 0.779 and 2.000
USDC) cannot pay 2.001 USDC in one payment, although the total covers it.
`node $W help` names the command that readies such a balance for one
payment: nothing leaves the pool, and our relayer pays every fee. After it,
wait for the next pool anchor (usually within a minute), then pay.

### 5. Check your balance and withdraw

```sh
node $W help balance
node $W help unshield
```

`unshield` sends some or all of your balance to a public Solana address; our relayer
sends the exit and pays its fees. Run `backup-export` again after each step
that moves value.

## The self-custody model

- Your keys are a Solana key and a shielded seed. `init` makes both on your
  machine. No sign-up, no Ethereum key, and no identity
  signature.
- We never receive your keys, seed, passphrase, or recovery file. We cannot
  recover them. If you lose the seed and the recovery file, your funds are
  lost.
- `restore` rebuilds the wallet from the recovery file. `recover` reads your
  shielded notes from your seed, the public chain history, and the public
  memos.
- The wallet writes deposit, payment, and unshield steps to its log before
  it sends them. After an interruption, run the same command again. The
  help of each command says how it resumes.
- Our relayer pays the network fees of relayed deposits and exits. A
  self-broadcast deposit and the first Privacy Cash step are paid by your own
  key.
- We never ask for your seed, passphrase, or recovery file. Anyone who asks
  is not us.

## What the privacy covers, and what it does not

What the chain does not show: who paid a seller from a Shinjuku Shielded
balance. With float pay, the chain shows a pool payment (the payer hidden)
and then a Shinjuku float pocket that pays the seller. Many buyers pay from
the same float pockets, so a chain observer cannot group one buyer's
purchases.

What it does not hide:

- **Our server sees what it processes**: your deposits, payments, and exits,
  their times, and the IP address of each request (a Tor exit with
  `--tor`).
- **Deposits are public.** A deposit's amount and time are public. With few
  depositors in a pool, time can pair your deposit with your later payments.
  When you are the only user (k=1), waiting buys nothing. Our pools are new
  and have few users.
- **Float pay: our server sees both sides.** For a float payment, our server
  sees that this private payment paid seller X, the price, the resource URL,
  and the time. It does not see your wallet. It keeps that link only until
  the payment is final or refunded.
- **Float pay: the seller's price is public.** The transfer from our float
  pocket to the seller shows the amount, the seller, and the time. It lands
  seconds after your pool payment, so time can pair the two.
- **Another facilitator sees its last step.** The seller's own facilitator
  settles the transfer from our float pocket. It sees our pocket, the
  seller, the amount, and the time, as the chain does.
- **Your own traces.** A keyed RPC URL names you. The timing of your
  requests links them. Everything you sign on chain is public.

Keys, audits, and limits:

- The production keys of the main shielded pool came from a
  single-operator offline setup. No multi-party ceremony has run.
- No independent audit of the circuits, the verifiers, or the binding has
  run.
- Do not expect a cold wallet to settle at once: on 2026-09-23 a payment
  took 1.5 to 4 minutes.
- A new deposit pays after the next pool anchor (about every 30 s when the
  pool grew; 12 of 12 within 45 s in our test on 2026-10-11). So a balance
  from several deposits can need one extra step and one anchor wait before a
  large payment.
- Float pay needs our float to hold enough. When it is busy or being filled,
  the wallet refuses before it pays (`p03_float_busy_retry_later`,
  `p03_float_not_ready_retry_later`); try again later.

## Copyright

Each wallet file comes with this notice (`LICENSE.txt` beside the file):

> Shinjuku Shielded wallet
> Copyright (c) 2026 Shinjuku Shielded. All rights reserved.
>
> The open-source packages inside this file keep their own licenses: see
> THIRD_PARTY_NOTICES.txt.

`THIRD_PARTY_NOTICES.txt` beside each release lists every open-source
component inside the file, with its license text. One of them,
`rpc-websockets`, is under LGPL-3.0-only.

## Security

See [SECURITY.md](SECURITY.md).
