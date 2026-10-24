# Proof: live mainnet transactions

Each row below is a real Solana mainnet transaction from our own test
runs. We read each one again from the public RPC
(`https://api.mainnet-beta.solana.com`, `getTransaction`, commitment
`finalized`): on 2026-10-08, and the float pay rows on 2026-10-11. Each one is finalized with `err: null`.

The amounts are small test amounts. These runs prove that the paths work.
They do not prove a large anonymity set: our pools are new and have few
users (see [privacy-model.md](privacy-model.md)).

## `shielded-exact`: a payment from the shielded balance

| Claim | Transaction | The chain shows | The chain does not show |
|---|---|---|---|
| A wallet paid a seller from its shielded balance over `--tor`, on production, 2026-10-07 19:39Z (22.7 s from start to the paid answer). | [`sq4NwDwU…WQp`](https://solscan.io/tx/sq4NwDwUASTns7wcg4CcXjLtZhAZH8bTqWodnXQZEc4P7vpiLutNhs12cUYPNJQ4DhUsP23K4WTqbVhGTWchWQp) | One call to the pool program (`8PYPw3FS…`), signed only by our fee payer (`6LhX4sv2…`). | Any token movement, the amount, the payer, the seller. |
| The same path, on production, 2026-10-07 19:16Z (21.9 s). | [`5khn7syZ…cs8n2`](https://solscan.io/tx/5khn7syZYS8m2mvmyjdJmuksehamPgUGRnqpSVCxtSnaFgXZQPae1cReowsR7HJv8uzPLoi7ef1B22hg2Hgcs8n2) | The same: one pool program call by our fee payer. | The same. |

## Float pay: an outside `exact` seller, paid by Shinjuku

On production, 2026-10-11. The sellers were our
own test sellers: stock `@x402/express` servers on the PayAI facilitator,
not pointed at our facilitator. Each payment is two transactions: the
buyer's private payment to us, then our float pocket's transfer to the
seller. We read all four again on 2026-10-11 from the public RPC
(`finalized`, `err: null`).

| Claim | Buyer payment to us | Transfer to the seller | The chain shows | The chain does not show |
|---|---|---|---|---|
| 0.10 USDC to a stock PayAI seller, 15 s, 08:27Z. | [`5v44HKT1…MpbG`](https://solscan.io/tx/5v44HKT15m24LdYy7PsHuZgTnQsQTWXfbDN7ZgTzTumDUXQGMAnqpCSshFUxB3XeY2nJ1CydsMbrKmNr9YgxMpbG) | [`3tDcBaMb…qrps`](https://solscan.io/tx/3tDcBaMbxKXnhfE3AmbmTeKAJ2oYFuswV5JUZdq3ay4VpjZhzepqWkgooqVqzRG3CJy5YX1gdYmFTEpWXYQCqrps) | Payment: one pool program call signed only by our fee payer (`6LhX4sv2…`). Transfer: 100,000 atomic USDC from a Shinjuku float pocket to the seller, signed by the seller's facilitator fee payer and the float pocket. | The buyer's wallet. The payment moves no token and shows no amount. |
| 1.50 USDC to a stock PayAI seller, 20 s, 08:52Z. | [`2KnWsvJV…hdwy`](https://solscan.io/tx/2KnWsvJV86EP8LtD6xhGJ46xFt4oRDdZCh6MZLFDftzhVQjebxTnNvCVxdH4JMLV9UPWsVRaMBG4qi8XuaqZhdwy) | [`q2nPBr6o…UAo2`](https://solscan.io/tx/q2nPBr6o2wRwRy8pCyevNmzb1mm9G3jHqTT7kE8dk21tQYRGjTb2v7wBJh3gDaVwcWqDNgqp6VjJgbW9FUDUAo2) | The same shape: 1,500,000 atomic USDC from a float pocket to the seller. | The buyer's wallet. |

Limits: each transfer to the seller landed 2 to 3 seconds after its buyer
payment, so time pairs them in a quiet pool. Our server saw which payment
paid which seller until each row was final.

### Float pay: a stock seller on our own facilitator

On production, 2026-10-11, with the MCP wallet. The seller was our own test
seller: a stock `@x402/express` server with its facilitator URL set to
`https://shinjukustaition.com/api/x402`. Our facilitator settled the
transfer and paid its network fee. We read all four again on 2026-10-11
from the public RPC (`finalized`, `err: null`). We pair each buyer payment
with its transfer by time: it is the only pool transaction in the 40 s
before the transfer, and our server logged one float payment in that
minute.

| Claim | Buyer payment to us | Transfer to the seller | The chain shows | The chain does not show |
|---|---|---|---|---|
| 0.01 USDC, a pre-release build of the same code, 16 s, 11:18Z. | [`251veadV…uELuh`](https://solscan.io/tx/251veadVto2mB3Y8dArE4c51YZMjDuYiNLQp3JuCrneK2rgvM63fqBqM4ntWTX4rrcTBg3XwxcuUStHLfHnuELuh) | [`2PyGE54t…QP8X`](https://solscan.io/tx/2PyGE54tbMKLqHCPfd1D2UDNPMEBhC4yvSGDcsJqhNP3xNT5Kr7BUfDK7X8a4tsTEP7YqQcM3EXo1PU5Kzv5QP8X) | Payment: one pool program call signed only by our fee payer (`6LhX4sv2…`). Transfer: 10,000 atomic USDC from a Shinjuku float pocket (`CXAvgXsa…`) to the seller, signed by our pocket fee payer (`zM8c2oE4…`) and the float pocket. | The buyer's wallet. The payment moves no token and shows no amount. |
| 0.01 USDC, wallet release `488372b4`, 17 s, 11:42Z. | [`5FY8uXY3…KL3d`](https://solscan.io/tx/5FY8uXY3M789TNNGn8Root69E2RGAHq4GAq25NZPGphYdDvx3ZXBF5GuBdfhKBSjuQ7fsSe3ssxD3Z6BB6fGKL3d) | [`3jPseh8T…TfoC`](https://solscan.io/tx/3jPseh8TsiCs5iyY6EENeEmBg2JFkP6zrWbU4BMd6c46d97igg9TT72pk2SYhS5dR5SiwU66aLU7AYWrvjN2TfoC) | The same shape. | The buyer's wallet. |

## `confidential`: hidden amount (Lane B, retired)

This scheme is retired: the V0b vault that it paid from was closed on chain
on 2026-10-11. The rows below stay as a record.

| Claim | Transaction | The chain shows | The chain does not show |
|---|---|---|---|
| A stock `@x402/express` 2.27.0 seller, pointed at our facilitator, was paid with scheme `confidential` on production, 2026-10-07 05:22Z. Price: 4,000 atomic (0.004 shUSDC). The seller's receipt check decrypted the slot to 4,000. | [`5AWtg8Ko…ai1t9`](https://solscan.io/tx/5AWtg8KoV9SxTLC5tRZB5b9ja3qwcedvcKGi4MBfhGz4UV5aiq7hotbUkvfytvvBE6S1rmoDgWERetNVN5Vai1t9) (the transfer; the last of 5 transactions) | A Token-2022 `confidentialTransfer` and 3 zero-knowledge proof checks. Signers: our fee payer and the payer's pocket. | The amount, the seller. |
| The same seller with the payment staged ahead: the seller's paid request took 1.591 s, on production, 2026-10-07 06:12Z. Price: 800 atomic. | [`3r8NK22H…JRovW`](https://solscan.io/tx/3r8NK22HGGrWRgYA81mumWG1v9NojRwYBMf3BjZ6qdEB1SuYdo1SRDppwBRyycSERgpfQ6XbANUXte3ajjEJRovW) | The same shape: one `confidentialTransfer` and 3 proof checks. | The amount, the seller. |
| Two fresh agents, each signed in with its own key, paid a Lane B quote on production, 2026-10-07 03:34Z. The payee ran every command over our onion service. Quote: 5,100 atomic. `laneb receipts --verify` said `verified`. | [`5hTvvNay…V6RLnZ`](https://solscan.io/tx/5hTvvNayfQKQ8zFnNdkJedssxvV7Ts92LBUWUsa94BnmDbd5Y8RHdFmMzzjh7YV5LufSM3x25pEFKCZW3bV6RLnZ) (one of 5 transactions) | One `confidentialTransfer` and 3 proof checks, signed by our fee payer and the payer's pocket. | The amount, the payee. |

Limit: one test key signs all three transfers above, so the chain links
these three test payments to each other. It does not show their amounts or
sellers. Our facilitator
saw the amount, the seller, and the URL of each payment.

## The MCP: shield, unshield, and pay from an agent

These runs used the wallet's local MCP server
([README](../README.md)) on
2026-10-08, before float pay replaced pockets.

| Claim | Transaction | The chain shows | The chain does not show |
|---|---|---|---|
| `wallet_shield` moved 1 USDC from the wallet's own key into the shielded pool. | [`hWzDiR1R…qrDizn`](https://solscan.io/tx/hWzDiR1RnC1gFXMMrCxRBCZ4R5dgMreWGX7vyQCTUTWkKaKnYvxmro6PQuE9KMYVbrq3NkNu9YaJzj7XaqrDizn) | The wallet's own key signs. 1,000,000 atomic USDC moves from its USDC address to the pool vault. A shield is public by design. | What the wallet later pays with it. |
| `wallet_unshield` sent 0.5 USDC to a public address: step 1, the self-payment. | [`5evVHz8X…Zr9uv`](https://solscan.io/tx/5evVHz8XvMdSYF76BQ1xv3TazwS9P38FEXp81gipNMMSqn61Rj7EUc1DdgpYz591wQbBZMWcpNVznixXPsfZr9uv) | One pool program call, signed only by our fee payer. | Any token movement, the amount. |
| The same unshield: step 2, the exit. | [`4yY2YXLS…apgF2i`](https://solscan.io/tx/4yY2YXLSj1EyUWDb7X9985KmyeNGQieF8skg3uN3sv3Pds3zSb42J5owDWMUTshui6XACkP4zwGxUmXXTVapgF2i) | 500,000 atomic USDC from the pool vault to the recipient. Our relayer signs and pays the fee. | The wallet that shielded: its key is not in the transaction. |
| `wallet_unshield` to an address that the human confirmed in the MCP client, 0.25 USDC, wallet release `1a336885`: the self-payment. | [`3jQyPgrA…QEWw`](https://solscan.io/tx/3jQyPgrA5AtFcqzyWHDWRcfNv66sM5qfCStxsByYDqGm7W5uRWkUMHpLoFUFm2jc98Aor7CXSToAChSHD7dWQEWw) | One pool program call, signed only by our fee payer. | Any token movement, the amount. |
| The same confirmed unshield: the exit. | [`4yA3qkHU…jCoh`](https://solscan.io/tx/4yA3qkHUto7e7iUGM9q6321avTm8aZQJ6zNMMh18SoAACnvgtvbWpVydry3mCq9iKaSZv92FfH43NJu557zjCoh) | 250,000 atomic USDC from the pool vault to the recipient. Our relayer signs and pays the fee. | The wallet that shielded. |
| `x402_pay` paid a standard `exact` seller from a pocket. | [`kX2zbbuR…P48wW`](https://solscan.io/tx/kX2zbbuRbskBQ2EnazyDBu7oZ7BtySVT7zDmtBn7ZivMm3guhLWrJGiPFFLzTEyxwTKUkeSAJjTJLSWLHYP48wW) | A standard USDC `transferChecked` of 1,000 atomic from the pocket to the seller, with a memo. Our `exact` fee payer (`zM8c2oE4…`) and the pocket sign. | The wallet's own key. |
| `wallet_shield` from a fresh wallet that held 0 SOL, 2 USDC, wallet release `94a357bc` (npm 0.3.0; the same code path is in `a8516e49`, npm 0.3.1), 2026-10-08. | [`5np1EYjN…qs1qV3fH2`](https://solscan.io/tx/5np1EYjNkr5w7Tt6ng2KQ9cp7RgNkhpwAKtzkm2nyRKMgi1FsmM3TMZMx8EkyiAV4sUtoQ3mTtTbuehas1qV3fH2) | Only our relayer signs and pays the fee. 2,000,000 atomic USDC move from the wallet's USDC address to the pool. A shield is public by design. | What the wallet later pays with it. |
| `x402_pay` paid a public satellite-imagery seller (0.013 USDC) from an automatic pocket of that wallet; the seller's own facilitator settled it, HTTP 200 with the JPEG in 8 s. | [`iC6gnjFM…xG9DHwC`](https://solscan.io/tx/iC6gnjFMBwHaqArgcRL6C5GdNbcWMom82cZqcQ2C2xup9aXJX91HXmWozQcVvAyTSTZsRptynfdbBPjjxG9DHwC) | A standard USDC `transferChecked` of 13,000 atomic from the pocket to the seller. The seller's facilitator fee payer and the pocket sign. | The wallet's own key, its shielded balance. |

Limits:

- An unshield shows the amount, the recipient, and the time. In these runs
  the shield and the unshields were minutes apart in a quiet pool. Timing
  and amounts gave weak cover.
- A pocket payment shows the pocket, the seller, and the amount.

## Check a transaction yourself

```sh
curl -s https://api.mainnet-beta.solana.com -H "Content-Type: application/json" -d '{
  "jsonrpc":"2.0","id":1,"method":"getTransaction",
  "params":["<signature>",{"commitment":"finalized","encoding":"jsonParsed","maxSupportedTransactionVersion":1}]
}'
```

Look at `meta.err` (it must be `null`), the signers in
`transaction.message.accountKeys`, and `meta.preTokenBalances` against
`meta.postTokenBalances`. A `shielded-exact` payment has no token balance
change.
