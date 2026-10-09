# Changelog

The Shinjuku Shielded MCP server is the `mcp` command of the wallet file
`shinjuku-wallet.mjs`. Each wallet release has its SHA-256 in the
[Releases table](https://github.com/ShinjukuStaition/shinjuku-shielded#releases)
of `ShinjukuStaition/shinjuku-shielded`. Dates are UTC.

## 2026-10-09: wallet release `14dd9efa`, npm `shinjuku-shielded@0.3.4`

- Proof tools `9975fdf8` pin the upgraded pool program. With 0.3.3, setup
  worked but every pocket fill failed (`p03_seller_chain_pin_mismatch`). Run
  `npx -y shinjuku-shielded@latest setup` once.

## 2026-10-09: wallet release `36d0219d`, npm `shinjuku-shielded@0.3.3`

- Required after the pool program upgrade of 2026-10-09: earlier releases
  refuse payments. Run `npx -y shinjuku-shielded@latest setup` once; it keeps
  your wallet and downloads proof tools `a9f18f88`.

## 2026-10-08: wallet release `d2a7291f`, npm `shinjuku-shielded@0.3.2`

- When the facilitator is short of network-fee funds, the agent hears
  `p03_facilitator_underfunded`: nothing was spent; try again later with a new
  request_id.
- A seller that closes a payment request now tells the agent to pay again with
  a NEW request_id.

## 2026-10-08: wallet release `a8516e49`, npm `shinjuku-shielded@0.3.1`

- A shield call made right after the MCP server starts now waits for the
  server's own background pocket check instead of failing `wallet_locked`.
- Tool texts name fewer third-party wallets.
- Otherwise the same as 0.3.0 (wallet release `94a357bc`, no longer served).

## 2026-10-08: wallet release `94a357bc`, npm `shinjuku-shielded@0.3.0`

Update from 0.2.0. The pool program was upgraded on 2026-10-08. The proof
tools that 0.2.0 pins (`24e819a8`) name the program from before the upgrade,
so setup from 0.2.0 now refuses production. 0.3.0 pins the new set
`262e1e98`.

- `x402_discover`: searches public x402 listings (Coinbase x402 Bazaar,
  PayAI, Dexter, and others) on your machine. The first call takes about
  15 s.
- Automatic pockets: for a standard `exact` seller, `x402_pay` fills a
  1 USDC pocket from the shielded balance when it needs one.
  `--ready-pockets 0-5` (default 1) sets how many stay ready.
  `--no-auto-pockets` turns this off.
- Image answers: `x402_pay` returns image bytes (also JSON `image_base64`)
  as an MCP image block and saves the file.
- `wallet_shield` needs no SOL. Our facilitator's relayer pays the network
  fee; you pay the shield cost.
- An Approve button with an empty form (Hermes) counts as accept.
- `x402_preview` and `x402_pay` price a seller that lists several networks
  from its Solana offer.
- The pool history comes through our facilitator's https history proxy by
  default. A new wallet is ready in about 60 s instead of about 220 s.
- A seller receipt that names another payer is checked on chain.
- A payment that landed, from a seller that gives no answer, closes as paid.
- Verified on production with a new wallet, the default setup, and no SOL at
  any time: a shield
  ([`5np1EYjN…fH2`](https://solscan.io/tx/5np1EYjNkr5w7Tt6ng2KQ9cp7RgNkhpwAKtzkm2nyRKMgi1FsmM3TMZMx8EkyiAV4sUtoQ3mTtTbuehas1qV3fH2)),
  then `x402_pay` to a public satellite-imagery seller: 0.013 USDC, HTTP 200
  in 8 s, a JPEG answer
  ([`iC6gnjFM…DHwC`](https://solscan.io/tx/iC6gnjFMBwHaqArgcRL6C5GdNbcWMom82cZqcQ2C2xup9aXJX91HXmWozQcVvAyTSTZsRptynfdbBPjjxG9DHwC)).

## 2026-10-08: wallet release `11fe6b40`, npm `shinjuku-shielded@0.2.0`

One command installs and runs it: `npx -y shinjuku-shielded mcp`.

- First run with no wallet: in a terminal it asks "Set up Shinjuku Shielded
  now? (y/n)". Started by an agent app, it serves a setup mode: the tools
  `shinjuku_setup` and `wallet_status`, and the app asks you "Create a
  Shinjuku Shielded wallet on this machine?" (MCP elicitation). Nothing is
  created until you accept. The money tools answer `wallet_not_set_up`.
- `setup` (also run by the first start): creates the wallet with a
  generated passphrase in a private file, shows the recovery file to back
  up, downloads the proof tools and checks every file against a set pinned
  inside the wallet (the server alone cannot change it), and writes
  `config.json`. `--add-to claude-code|claude-desktop|cursor` adds the server
  to your agent app. `--yes` asks nothing.
- `mcp` with no flags reads `config.json`. Flags on the command line still
  win.
- Linux, or Windows with WSL. macOS is not supported (the provers are Linux
  programs).
- In the official MCP Registry as `io.github.ShinjukuStaition/shinjuku-mcp`
  0.2.0. npm versions are published from this repository's workflow with
  npm provenance (from 0.1.1).
- Verified on production: an end-to-end run from the published package
  (setup in 25 s, `mcp` with no flags, a balance read).

## 2026-10-08: npm `shinjuku-shielded@0.1.1` (same wallet release `1a336885`)

- `server.json` for the official MCP Registry
  (`io.github.ShinjukuStaition/shinjuku-mcp`).
- `mcpName` in `npm/package.json`. The registry checks it on npm, so it
  needs a new npm version before the registry entry.
- `examples/`: Claude Code, Claude Desktop, Cursor, and Hermes Agent configs,
  a first-10-minutes walkthrough, and 10 plain requests.
- `SECURITY.md`.

## 2026-10-08: wallet release `1a336885`, npm `shinjuku-shielded@0.1.0`

The MCP runs by itself. You talk in plain words, and the server does the
upkeep.

- `wallet_shield` is on by default with `--proof-tools`. `--no-shield`
  turns it off. `--max-shield` is optional. `--allow-shield` is still
  accepted for older configs.
- `wallet_unshield` is on with `--exit-proof-tools` and `--profile`. An
  address in `--unshield-to` is sent at once. Any other address is sent only
  after you confirm it in your MCP client (MCP elicitation): "Send X USDC
  from your shielded balance to <address>?". A decline, or no answer in 5
  minutes, sends nothing (`mcp_unshield_declined`). A client that cannot ask
  is refused (`mcp_unshield_to_not_allowed`). `--max-unshield` is optional.
- The wallet's own key is refused as a send address. It made the deposits,
  so a send there would link them. The server does not start when
  `--unshield-to` names it.
- Automatic refresh: after a deposit lands, and before a payment or a send
  when the local balance is stale, the server reads the chain itself.
  `wallet_balance` answers with `refreshing: true` after about 20 s and
  finishes in the background.
- Automatic backup: after each shield and each send, the wallet writes an
  encrypted backup to `$SHIELDED_WALLET_HOME/auto-backups/<pool>/` and keeps
  the newest 5.
- A send is your own money. It does not count against the payment budget of
  the wallet file (`init --max-payment`, `--max-cumulative`). Payments to
  sellers still count.
- The server instructions and the tool descriptions map plain requests
  ("what is my balance", "shield 5 USDC", "pay this URL", "send 2 USDC to
  <address>") to one tool each.
- npm: `shinjuku-shielded@0.1.0` holds this release unchanged
  (`shinjukuRelease` `1a336885`). Commands: `shinjuku-shielded` and
  `shinjuku-wallet`.

## 2026-10-08: wallet release `b7d6f394`

- New tool `wallet_shield {amount_atomic, request_id}`: moves the public
  USDC on the wallet's own key into the shielded balance. Off unless you
  start the server with `--allow-shield --max-shield <atomic>`.
- New tool `wallet_unshield {amount_atomic, to, request_id}`: sends shielded
  USDC to a public Solana address. Off unless you start the server with
  `--unshield-to <address> --max-unshield <atomic>`.
- Both take minutes. The same `request_id` reads the status and never moves
  money twice, also after a restart.
- `wallet_balance` shows SHIELDED and UNSHIELDED separately: the private
  balance, and the plain USDC on the wallet's own key.

## 2026-10-07: the `mcp` command

- `shinjuku-wallet mcp`: a local MCP server on stdio. Your keys and
  passphrase stay in that process.
- Tools: `x402_preview` (the price and the cap check; pays nothing),
  `x402_pay` (alias `fetch_paid`; pays and returns the answer),
  `wallet_balance`, `wallet_receipts`, `wallet_cancel`.
- Caps: `--max-payment` and `--max-session` are required. Without them the
  server does not start (`mcp_cap_required`). A tool argument can only lower
  the per-payment cap. Optional: `--max-per-host-day` and `--allow-host`.
- The same `request_id` never pays twice.
- Pays `shielded-exact` from the shielded balance and standard `exact` from
  a ready pocket. Not `confidential`.
- `--tor` sends seller requests, memo reads, and RPC calls through Tor.
