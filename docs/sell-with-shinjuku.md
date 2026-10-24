# Sell with Shinjuku Shield

This page says how a seller gets paid by Shinjuku Shield buyers. It uses
public files only.

**What you can sell with today:**

| Your seller setup | Do Shinjuku Shield buyers pay you? | What stays hidden on chain |
|---|---|---|
| Standard x402 `exact`, Solana USDC, on your current facilitator (Coinbase CDP, PayAI, or any other) | Yes, through float pay. You change nothing. | The buyer's wallet. The chain shows a Shinjuku float pocket paying you. |
| `shielded-exact` | **Not public yet.** The seller package is not in the wallet file and not on npm. Today it needs our private source repository. | The payer and the amount. |
| Standard x402 `exact`, Solana USDC, pointed at our facilitator (`https://shinjukustaition.com/api/x402`) | Yes, through float pay, with wallet release `08a4b56f` (npm 0.3.8) or later. | The buyer's wallet. The chain shows a Shinjuku float pocket paying you. |
| `confidential` (Lane B, hidden amounts) | **Retired.** The V0b vault that buyers paid from was closed on chain on 2026-10-11. | |

## A standard `exact` seller: float pay

Keep your standard x402 `exact` middleware and your facilitator. When a
Shinjuku Shield buyer asks for your URL:

1. Your server answers its normal 402.
2. The buyer's wallet pays us privately from its shielded balance: your
   price plus our fee.
3. We sign a standard `exact` payment to you from one of our shared float
   pockets.
4. The buyer's wallet sends your URL that payment. Your facilitator verifies
   and settles it as any other `exact` payment, and you answer.

The largest price that one float payment can pay is the size of our largest
float pocket: `largestAtomic` in
`GET https://pay.shinjukustaition.com/api/x402/float/config` (3 USDC on
2026-10-11). A buyer's wallet refuses a higher price before it pays. On
2026-10-11 float pay paid two stock `@x402/express` sellers on the PayAI
facilitator, 0.10 and 1.50 USDC, and a stock seller on our own
facilitator, 0.01 USDC twice: see [proof.md](proof.md). On our own
facilitator, we also pay the network fee of the transfer to you.

### What you see, and what we see

- You and your facilitator see a Shinjuku float pocket, the price, and the
  time. You do not see the buyer's wallet. You see the buyer's IP unless it
  uses `--tor`.
- We see that a private payment paid you, the price, the URL, and the time,
  until the payment is final or refunded. We do not see the buyer's wallet.
- The chain shows our float pocket paying you, the amount, and the time.
  Many buyers pay from the same float pockets.

## Get listed (opt-in)

Buyers find sellers in our list:
`GET https://shinjukustaition.com/api/x402/discovery/catalog.json`.
The list takes no search terms. Buyers filter it on their own side.

To get listed:

1. Publish `/.well-known/x402-discovery.json` on your own https origin:

   ```json
   {"schema":"x402-discovery/v1","resources":[{"url":"https://seller.example/paid","method":"GET"}]}
   ```

2. Send:

   ```sh
   curl -fsS -X POST https://shinjukustaition.com/api/x402/discovery/register \
     -H "Content-Type: application/json" -d '{"origin":"https://seller.example"}'
   ```

We list a URL only when its unpaid request answers a 402 that our
facilitator settles. The answer names each refused URL with `next`. To delist a URL,
remove it from the file and register again. Limits: 50 URLs per origin, and
6 register calls per minute per IP.

A listed seller is public by its own choice. The register check reaches your
server from our server's IP.
