# Changelog

The Shinjuku Shielded MCP server is the `mcp` command of the wallet file
`shinjuku-wallet.mjs`. Each wallet release has its SHA-256 in the
[Releases table](https://github.com/ShinjukuStaition/shinjuku-shielded#releases)
of `ShinjukuStaition/shinjuku-shielded`. Dates are UTC.

## Unreleased

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
