# Privacy model

This page says who sees what. Every claim carries its limit. If a limit here
is wrong, report it: [SECURITY.md](../SECURITY.md).

Two things are separate:

1. **On-chain privacy.** What the Solana chain shows. The scheme decides it.
2. **Network privacy.** Who sees your IP address and your requests. The
   transport decides it (default, VPN, or `--tor`).

`--tor` does not change on-chain privacy. A scheme does not hide your IP.

## Who sees what, for each scheme

"Our facilitator" means our server: the facilitator, the relayer, the memo
service, and the RPC relay.

### `shielded-exact` (payer hidden in the pool)

| Party | Sees | Does not see |
|---|---|---|
| Chain | A pool program call signed by our fee payer, and its time. | The payer, the amount, and any token movement. |
| Seller | Your request, the price, the time, and your IP unless you use `--tor`. | Your wallet's key. |
| Our facilitator | What it processes: the payment, its time, and the IP of each request (a Tor exit with `--tor`). | Your keys and seed. |
| RPC | With our relay (the default): which addresses your wallet reads, the transactions it sends, and your IP unless `--tor`. With your own RPC: the same, at your provider. | Your keys. |
| MCP host and model provider | Every URL, body, price, and paid answer the agent handles. | Your keys and passphrase: they stay in the wallet process. |

Limit: the payer is hidden only among the pool's other users. See "Privacy
needs a crowd" below.

### Float pay (an outside `exact` seller, paid by us)

Your wallet pays us privately with `shielded-exact` (price plus fee). We
then pay the seller from one of our shared float pockets, and the seller's
own facilitator settles that transfer.

| Party | Sees | Does not see |
|---|---|---|
| Chain | Your payment to us: a pool program call, as for `shielded-exact`. Then a transfer from a Shinjuku float pocket to the seller: the amount, the seller, and the time. | Your wallet. Many buyers pay from the same float pockets, so a chain observer cannot group one buyer's purchases. |
| Seller | A Shinjuku float pocket, the price, the time, and your IP unless `--tor`. | Your wallet. |
| The seller's facilitator | Our float pocket, the seller, the amount, and the time. | Your wallet. |
| Our facilitator | That this private payment paid seller X: the price, the resource URL, and the time. It keeps that link only until the payment is final or refunded. The IP of each request (a Tor exit with `--tor`). | Your wallet's key and seed. |
| MCP host and model provider | Every URL, body, price, and paid answer. | Your keys. |

Limits: until a float payment is final or refunded, our server holds your
private payment and the seller transfer together. The seller's price is
public on chain, as it is in its 402. The transfer to the seller lands
seconds after your pool payment, so time can pair the two; the pool payment
still does not show your wallet. If the seller does not take the
payment, the refund is a private payment back to a one-time recipient of
your wallet.

Retired: scheme `confidential` (hidden amounts, Lane B) and the V0b vault
it paid from. The V0b program was closed on chain on 2026-10-11. Per-user
pockets are replaced by float pay. An old pocket shows its own payments on
chain; `pocket reshield` returns its USDC to the shielded pool.

### Money in and money out

| Step | The chain shows | The chain does not show |
|---|---|---|
| A deposit from your own key (`deposit`, MCP `wallet_shield`) | Your key, the amount, and the time. | Your later payments. |
| A relayed deposit from a one-time address (`add-funds`) | The one-time address, the amount, and the time. | Your wallet's own key. |
| An unshield | The amount, the recipient, and the time. | Which deposit paid it. |

The funding route also sees you. An exchange knows you, the amount, and the
address. ChangeNOW sees the amount and the address. Never fund a one-time
address from a wallet that you use elsewhere: that transfer links you.

## Privacy needs a crowd

A shielded pool hides you among its other users. With few users, time and
amounts can link a deposit to a payment. When you are the only user (k=1),
waiting buys nothing.

Our pools are new and have few users. This is the main limit of Shinjuku
Shield today. Float pay helps on the seller side: every buyer's outside
payments leave from the same Shinjuku float pockets. It does not hide a
deposit from the pool's small crowd.

## Your network: default, VPN, or `--tor`

| Mode | Who sees your IP | Who sees your requests |
|---|---|---|
| Default (`https://pay.shinjukustaition.com`) | Our server and the seller. | Our server and the seller. No CDN: this host skips Cloudflare. |
| A VPN or `--proxy` | The VPN company. We and the seller see the VPN's address. | The VPN company sees every request (which seller, which addresses). We and the seller see them too. |
| `--tor` | No single party sees both who you are and what you request. | Our onion service and the seller, without your IP. |

- `--tor` needs one line in `torrc`:
  `HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr`. The wallet checks that it
  reaches the network through Tor before it sends any other request.
- With `--tor`, every request to our facilitator goes to its onion service.
  It adds about 1 to 2 seconds per request.
- Our RPC relay calls the Solana RPC provider from our own server. The
  provider never sees your IP when you use our relay.
- A keyed RPC URL names its owner. With `--tor`, use an RPC URL
  that has no API key in it, or use our relay.
- `--ohttp-relay <url>` sends RPC and x402 requests as Oblivious HTTP. The
  relay sees your IP, not the request. It helps only if someone other than
  us runs the relay.

### Cloudflare is not in the payment path

`https://pay.shinjukustaition.com` is the wallet's default facilitator. It
skips Cloudflare, so no CDN sees your IP or your requests. Our server still
does. `https://shinjukustaition.com` (the main site) is behind Cloudflare.

## Logs

- Our web server removes the client IP, port, and headers from its log
  lines.
- The RPC relay keeps no request log.
- The opt-in seller list holds seller data only: no buyer data and no
  payment counts. The list routes take no search terms, so we never learn
  what a buyer looks for.

Limit: our process sees each request in memory while it answers it. "No
log" is a policy. You must trust it. `--tor` removes your IP from what we
can see.

## What our operator can do

- **See what it processes.** Our server sees your deposits, payments, and
  exits, their times, and the IP of each request (a Tor exit with `--tor`).
- **Link a float payment to its seller.** For float pay, our server sees
  which private payment paid which seller, the price, the URL, and the time,
  until the payment is final or refunded. It does not see your wallet.
- **Setup keys.** The proving keys came from single-operator setups. No
  multi-party ceremony has run.
- **No audit.** No independent audit of the circuits, the verifiers, or the
  binding has run.

## Your own traces

- A keyed RPC URL names you.
- The timing of your requests links them.
- Everything you sign on chain is public.
- Over MCP, a local model removes the model provider as an observer.
