# Changelog

Wallet releases (`shinjuku-wallet.mjs`), newest first. Each release ID is
the first 8 hex characters of the file's SHA-256. The full hashes are in the
Releases table of the [README](../README.md). Each release keeps everything
in the release before it.

This file stops at `08a4b56f` (npm 0.3.8). Every later release, to the
current `f3c65200` (npm 0.3.63, 2026-10-22), is in the
[CHANGELOG](../CHANGELOG.md).

## 2026-10-11 (pool program upgrade)

- `08a4b56f`: on npm as `shinjuku-shielded@0.3.8`. Same pool
  (`45mhosfA2MuygZWeqYRVcEZX2Q3gA8KR8FwP6AZkK1zR`), new proof tools
  (`47678912`). Update now: the pool program was upgraded on 2026-10-11, and
  `488372b4` and earlier pin the old program and cannot pay. Run
  `npx -y shinjuku-shielded@latest setup` once. Your wallet, its address,
  and its balance stay the same. It keeps everything in `394d020a`, and adds:
  - When an earlier payment is not finished, the refusal
    (`p03_resource_payment_another_request_unresolved`) names its request
    id. Run its pay command again with the same `--request-id` to finish it;
    it never pays twice. `balance --refresh` lists it with its `requestId`.
- `394d020a` (served for a short time on 2026-10-11, not on npm):
  - Float pay works on the upgraded pool. `19542942` could not read the
    new pool layout when it returned float change.
- `19542942` (served for a short time on 2026-10-11, not on npm):
  - Pins the upgraded pool program and proof tools `47678912`.
  - A new piece of the balance pays sooner: the pool takes an anchor about
    every 30 s when it grew, not only every 5 minutes. In our test on
    2026-10-11, 12 of 12 new pieces could pay within 45 s (median 18 s).

## 2026-10-11 (later)

- `488372b4`: on npm as `shinjuku-shielded@0.3.7`. Same pool
  (`45mhosfA2MuygZWeqYRVcEZX2Q3gA8KR8FwP6AZkK1zR`) and same proof tools
  (`ad860e62`). It keeps everything in `9f9b4039`, and adds:
  - An error prints its code by name. 91 float pay, refund, and seller
    codes printed as `unknown_error` before.
  - The error line prints only the wallet's own messages. No text from a
    library can reach it.
- `9f9b4039` (served for a short time on 2026-10-11, not on npm):
  - Float pay also pays a stock `exact` seller that settles on our own
    facilitator. `e3348092` refused it
    (`p03_float_seller_uses_our_facilitator`).
  - A refund comes back within about 7 minutes, not 2: it waits for the next
    pool anchor. The wallet counts it in your one balance for 8 minutes.
  - A seller that offers only scheme `confidential` is refused with
    `confidential_retired`, and nothing is paid. `--play-token-file` is
    accepted and ignored. The `v0b` and `laneb` commands are removed.
  - The wallet spends the oldest piece that pays, so fresh change is not
    tied to your next payment.
  - The wallet reads the faster pool anchors (one about every 30 s) that a
    coming upgrade of the pool program adds. Until that upgrade, nothing
    changes: a piece waits for the next 5-minute anchor.

## 2026-10-11

- `e3348092`: on npm as `shinjuku-shielded@0.3.6`. Same pool
  (`45mhosfA2MuygZWeqYRVcEZX2Q3gA8KR8FwP6AZkK1zR`) and same proof tools
  (`ad860e62`).
  - Float pay. A seller that takes only standard x402 `exact` (Coinbase
    CDP, PayAI, any Solana `exact` seller that takes USDC) is paid through
    Shinjuku. The wallet pays us privately from the shielded balance, the
    seller's price plus a flat fee of 0.001 USDC, and we pay the seller from
    our own shared float. This replaces per-user pockets: you fill nothing
    and wait for no pocket. If the seller does not take the payment, we
    refund price and fee to your shielded balance by ourselves.
    `GET https://pay.shinjukustaition.com/api/x402/float/config` shows the
    fee and the largest price that one request can pay.
  - New command (named `prepare` from 0.3.95): gathers split pieces, so one payment can spend the
    whole balance. One payment spends one piece plus at most 3 notes.
  - New command `limits`: shows a wallet file's caps, and changes or removes
    them (`none` removes a cap).
  - Old pockets: `pocket reshield` returns an old pocket's USDC to the
    shielded balance. Until then, the MCP's one balance still counts it.
  - Hidden amounts (scheme `confidential`, the V0b vault) are retired. The
    V0b program was closed on chain on 2026-10-11.

## 2026-10-10

- `f2ea6840`: on npm as `shinjuku-shielded@0.3.5`. The pool program
  was upgraded and the shielded pool moved to
  `45mhosfA2MuygZWeqYRVcEZX2Q3gA8KR8FwP6AZkK1zR`; the old pool
  `AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8` is retired. Run
  `npx -y shinjuku-shielded@latest setup` once: it keeps the old wallet file,
  makes a wallet for the new pool (a new address), and downloads proof tools
  `ad860e62`. No spending limit by default (the caps are optional; a setup
  rerun lifts the old default caps). The first deposit into an empty pool
  works.

## 2026-10-09

- `14dd9efa`: on npm as `shinjuku-shielded@0.3.4`. Proof tools `9975fdf8`
  pin the upgraded pool program, so pocket fills and payments work again. Run
  `npx -y shinjuku-shielded@latest setup` once.
- `36d0219d`: required after the pool program upgrade of 2026-10-09.
  On npm as `shinjuku-shielded@0.3.3`. Wallets from earlier releases refuse
  payments (`p03_program_history_compatibility_not_reviewed`). Run
  `npx -y shinjuku-shielded@latest setup` once: it keeps your wallet and
  downloads proof tools `a9f18f88`.

## 2026-10-08

- `d2a7291f`: the same as `a8516e49`, with clearer answers. On npm as
  `shinjuku-shielded@0.3.2`.
  - When the facilitator is short of network-fee funds, the agent hears
    `p03_facilitator_underfunded`: nothing was spent; try again later with a
    new request_id.
  - A seller that closes a payment request now tells the agent to pay again
    with a NEW request_id.
- `a8516e49`: the same as `94a357bc`, with two fixes. On npm as
  `shinjuku-shielded@0.3.1`.
  - A shield call made right after the MCP server starts now waits for the
    server's own background pocket check instead of failing `wallet_locked`.
  - Tool texts name fewer third-party wallets.
- `94a357bc`: pays more sellers with less setup. On npm as
  `shinjuku-shielded@0.3.0`.
  - New proof tools `262e1e98`. They pin the pool program's new program data
    after the pool program upgrade of 2026-10-08. The earlier set `24e819a8`
    pinned the program from before the upgrade, so setup from npm 0.2.0 now
    refuses production. Update to 0.3.0.
  - MCP `x402_discover` searches public x402 listings (Coinbase x402 Bazaar,
    PayAI, Dexter, and others) on your machine. The first call takes about
    15 seconds.
  - Automatic pockets: for a standard `exact` seller, `x402_pay` fills a
    1 USDC pocket from the shielded balance when it needs one.
    `--ready-pockets 0-5` (default 1) keeps pockets ready;
    `--no-auto-pockets` turns this off.
  - Image answers: `x402_pay` returns image bytes (also JSON `image_base64`)
    as an MCP image block and saves the file.
  - `wallet_shield` needs no SOL. The facilitator's relayer pays the network
    fee; you pay the shield cost.
  - An Approve button with an empty form (Hermes) counts as accept.
  - `x402_preview` and `x402_pay` price a seller that lists several networks
    from its Solana offer.
  - Pool history comes through the facilitator's https history proxy by
    default. A new wallet is ready in about 60 seconds instead of about 220.
  - A seller receipt that names another payer is checked on chain.
  - A payment that landed, from a seller that gives no answer, closes as paid.
- `11fe6b40`: one command sets everything up. `npx -y shinjuku-shielded mcp`
  on a machine with no wallet offers setup (a y/n prompt in a terminal; in an
  agent app, a "Create a wallet?" confirmation). Setup creates the wallet with
  a generated private passphrase, downloads the proof tools and checks them
  against a set pinned inside the wallet, and writes a config file, so `mcp`
  needs no flags. On npm as `shinjuku-shielded@0.2.0`.
- `1a336885`: a relayed exit proof that is still valid and was
  never sent is sent again at once, instead of waiting for it to expire.
  On npm as `shinjuku-shielded@0.1.0` and `0.1.1`.
- `2c2f9874`: the MCP handles everything itself. `wallet_shield` is on by
  default. `wallet_unshield` sends to an address you listed at once, or to any
  other address only after you confirm it in your MCP client. The wallet's own
  key is refused as a destination. The wallet refreshes itself and writes an
  encrypted backup after each shield and unshield. Sending your own money out
  no longer counts against the wallet's payment budget.
- `c4a50798`: pocket reshield: the public USDC left in a pocket returns to the
  shielded balance.
- `b7d6f394`: MCP `wallet_balance` has one meaning for `unshieldedAtomic`
  (the public USDC on the wallet key). The total of finished unshields is now
  `detail.unshieldedTotalAtomic`.
- `63316238`: a payment never spends a note that an unfinished exit will
  spend. An exit whose note another payment spent is marked released, not
  stuck.
- `565c4f87`: an unshield waits for the next pool anchor instead of stopping.
  An exit proof that expired before it was sent is proved again.

## 2026-10-07

- `57bfd2fd`: with `--tor`, the Tor circuit to your own RPC is warmed up in
  parallel, so a payment starts faster.
- `768001dd`: a refused payment whose input another settled payment spent no
  longer blocks the wallet.
- `b4c514cd`: one chain clock read before a payment is sent. The wait for a
  single funded piece names `add-funds --split`.
- `061adadb`: the quote-time check uses one chain clock read.
- `721b8d65`: the saved deployment check gets one more try after a network
  failure.
- `97d6703d`: a faster, parallel first read of the item card keeps the
  correct answer.
- `3765885f`: the proof inputs are built once per payment, not once per
  input.
- `c6afbdbe`: compact pool history first, with retries and timeouts over
  Tor. The default facilitator is now `https://pay.shinjukustaition.com`,
  which skips Cloudflare.
- `6909057a`: memos are read ahead, and Tor circuits warm up early.
- `bf2652a3`: one bulk read for the buffer lists.
- `dc92be17`: money decisions bind to the on-chain pool root. A faster proof
  step. A UTF-16 passphrase file is refused with a fix. New `v0b unshield`.
- `551f8ad9`: new `keep-warm`. With `--tor`, every request to our
  facilitator goes to its onion service.
- `33d54d54`: timing marks before a payment, a 10 s limit on the item card
  read, and the epoch anchor read ahead of the 402.
- `0a638498`: retries for the item card, and a new Tor circuit after a
  history timeout.
- `c7abfaaf`: the history cache stops at its snapshot.
- `a66228ab`: `laneb pay-url` stages the proof data on chain first, so the
  seller's settle sends one transaction. A smaller proof-tools set
  (`82b2d870`). Bulk history reads.
- `c0fb991f`: scheme `confidential` for x402 sellers (`laneb pay-url`,
  `laneb seller info`, with the amount proof). New `curl` and `mcp`
  commands, with spend caps. No RPC of your own needed: the facilitator's
  relay is the default. The next payment no longer waits for the previous
  payment's finality.
- `cbd97cea`: the `laneb` command group (Lane B, hidden amounts): payee
  register, slots, quote, pay, receipts, and slot return.

## 2026-10-06

- `833aeed3`: a faster wait before the history walk, one walk reused,
  parallel buffer reads, and a new blinded point on a requote.

## 2026-10-05

- `f561eccf`: history proxy phase 2 and the production onion pinned in the
  wallet. A hint when a quote ended. Self-payments walk the history before
  the 402.

## 2026-10-02

- `68aac3c1`: the first release in this table. With its proof tools, a
  filled pocket pays any Solana x402 `exact` endpoint that takes USDC,
  whichever facilitator settles it.
