# Plain requests

Talk to your agent the way you talk to a person. The server tells the agent
which tool fits each request. Every answer is JSON text with a `next` field
that names the next call, or says that there is nothing to do.

Amounts are atomic USDC: 1000000 = 1 USDC. The `<...>` values below are
placeholders, not real values.

| # | You say | The agent calls | The answer |
|---|---|---|---|
| 1 | "what is my balance" | `wallet_balance {}` | `balanceAtomic` (one number, what the agent pays with), `breakdown` (`shieldedAtomic`, what the agent sends with; `refundsInFlightAtomic`; `setAsideAtomic`), `unshieldedAtomic` (plain USDC on the wallet's own address), `ownAddress`, `status` (`"current"` when the balance is read), and `next`. |
| 2 | "add 0.50 USDC to my shielded balance" | `wallet_add_funds` | A new one-time Solana address of this wallet and a `solana:` pay link. Send USDC to it from any wallet or exchange, from 0.01 USDC; no SOL is needed. It becomes private by itself a few minutes after it arrives, while the server runs. One round takes up to 5 USDC; a larger amount goes in by rounds. Use each address for one payer. The call itself moves no money. |
| 3 | "what is my wallet's own address?" | `wallet_balance {}` | `ownAddress`: the wallet's own public Solana address. `unshieldedSolLamports` shows its SOL. USDC on this address goes in with `wallet_shield`, which needs no SOL. |
| 4 | "shield 5 USDC" | `wallet_shield {amount_atomic: "5000000", request_id: "shield-1"}` | A `stage` (`proving`, `sending`, `done`). The first call starts the deposit of USDC that is already on the wallet's own address. `next` says to call again with the same `request_id` in 30 s. |
| 5 | "is the shield done?" | `wallet_shield` with the same `request_id` and `amount_atomic` | The current `stage`. At `done`, `refreshing: true` until the balance is read from the chain, then `backupPath` (the encrypted backup). |
| 6 | "what does https://seller.example/report cost?" | `x402_preview {url}` | For an x402 seller: the offers (scheme, network, `amountAtomic`, asset), the rail the wallet would use, the price, and whether your caps allow it. For a standard `exact` seller also `feeAtomic` (our fee) and `totalAtomic` (price plus fee). It pays nothing. For a URL that is not x402: `paymentRequired: false` and the HTTP status. |
| 7 | "pay it" | `x402_pay {url}` | `{ok, paid, requestId, transaction, scheme, amountAtomic, ...}` and the seller's answer in `body`. A large or binary answer goes to a file, and `bodyFile` names it. An image answer also comes back as an MCP image block. |
| 8 | "get that report, but pay at most 0.01 USDC" | `x402_pay {url, max_payment_atomic: "10000"}` | The same as 7. A higher price is refused before anything is signed. An argument can only lower the launch cap, never raise it. |
| 9 | "ask an AI model privately" | `inference_chat` | One AI answer from usePod's x402 chat endpoint, paid privately from the shielded balance. A short `qwen3-8-flash` answer costs about 0.0011 USDC: the provider price plus the 0.001 USDC Shinjuku fee. It needs `--tor` or a proxy. |
| 10 | "send 2 USDC to <address>" | `wallet_unshield {amount_atomic: "2000000", to: "<address>", request_id: "send-1"}` | Your client asks you first: "Send 2 USDC from your shielded balance to <address>?" (not for an `--unshield-to` address). Then a `stage` (`confirming`, `queued`, `refreshing`, `self-pay`, `exit`, `done`). At `done`: `exitTransaction` and `backupPath`. |
| 11 | "show my receipts" | `wallet_receipts {}` | `{ok, count, total, facilitatorNote, receipts}`. Each receipt has `kind` (`x402`, `inference`, or a move), the host (never the full URL), `amountAtomic`, and `transaction`. |
| 12 | "cancel the payment that is stuck" | `wallet_cancel {request_id}` | Closes one unfinished payment so its reserved balance comes back. It also closes the pieces of a private send that did not start, or an add-funds link that no USDC reached. A payment that never left the wallet closes at once. A sent one closes only after its quote expired and the pool history shows it never landed. It pays nothing. |
| 13 | "find a seller of satellite images" | `x402_discover` | Matching sellers from public x402 listings (Coinbase x402 Bazaar, PayAI, Dexter, and others). The search runs on your machine. It pays nothing. The first call takes about 15 s. |

## Refusals

A refusal is a normal answer, not a crash:

```json
{
  "ok": false,
  "error": "mcp_tool_disabled",
  "detail": "wallet_shield is off: the owner did not enable it when starting this MCP server",
  "next": "Nothing was moved. Tell your owner: wallet_shield needs the server started with --proof-tools (and without --no-shield)"
}
```

The agent does what `next` says. Some codes that you can see:

| Code | Why |
|---|---|
| `spend_payment_cap_exceeded` | The price is above the per-payment cap. Nothing was paid. Only you can raise a cap, at launch. |
| `mcp_session_cap_exceeded` | This wallet reached its 24-hour limit `--max-session` (all MCP processes together). |
| `mcp_cap_argument_above_launch_cap` | The agent asked for a cap above the launch cap. |
| `mcp_tool_disabled` | The tool is off. `next` says which flag turns it on. |
| `mcp_unshield_declined` | You did not confirm a send (decline, cancel, or 5 minutes with no answer). Nothing was signed. |
| `mcp_unshield_to_not_allowed` | The address is the wallet's own address, or your client cannot ask you and the address is not in `--unshield-to`. |
| `p03_float_refund_pending` | A standard `exact` seller did not take our payment. The refund comes back to the balance by itself within about 7 minutes (it waits for the next pool anchor). Use a new `request_id` to try again. |
| `p03_resource_payment_another_request_unresolved` | An earlier payment is not finished. The answer names its `request_id`. Call `x402_pay` again with that `request_id`: it finishes the payment and never pays twice. Then pay the new one. |
| `confidential_retired` | The seller offers only scheme `confidential` (hidden amounts). Those payments are retired. Nothing was paid. |
| `p03_float_price_above_capacity` | The price is above the largest price that our float pays for one request. Nothing was paid. |
| `p03_float_busy_retry_later`, `p03_float_not_ready_retry_later` | Our float is busy or is being filled. Nothing was paid. Call again later with the same `request_id`. |
| `p03_merchant_respend_insufficient_recovered_value` | The balance covers the price only in total, over several deposits. Run the command that `next` names (it readies the balance for one payment), wait for the next pool anchor (usually within a minute), then pay again. |
| `wallet_spend_refused_per_payment_cap_exceeded` | A cap in the wallet file refused it. You change it with `shinjuku-wallet limits`. |
| a code that ends in `_retry_same_request` | Call `x402_pay` again with the same `request_id`. It never pays twice. |
