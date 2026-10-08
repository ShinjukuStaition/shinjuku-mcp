# Plain requests

Talk to your agent the way you talk to a person. The server tells the agent
which tool fits each request. Every answer is JSON text with a `next` field
that names the next call, or says that there is nothing to do.

Amounts are atomic USDC: 1000000 = 1 USDC. The `<...>` parts below are
placeholders, not real values.

| # | You say | The agent calls | The answer |
|---|---|---|---|
| 1 | "what is my balance" | `wallet_balance {}` | `shieldedAtomic` (private, what the agent pays and sends with), `unshieldedAtomic` (plain USDC on the wallet's own address), `pocketsAtomic`, `session` (the caps, what this process paid, what it may still pay), and `next`. |
| 2 | "what address do I fund?" | `wallet_balance {}` | `ownAddress`: the wallet's own public Solana address. `unshieldedSolLamports` shows its SOL (a shield needs about 0.01 SOL). |
| 3 | "shield 5 USDC" | `wallet_shield {amount_atomic: "5000000", request_id: "shield-1"}` | A `stage` (`proving`, `sending`, `done`). The first call starts the deposit. `next` says to call again with the same `request_id` in 30 s. |
| 4 | "is the shield done?" | `wallet_shield` with the same `request_id` and `amount_atomic` | The current `stage`. At `done`, `refreshing: true` until the balance is read from the chain, then `backupPath` (the encrypted backup). |
| 5 | "what does https://seller.example/report cost?" | `x402_preview {url}` | For an x402 seller: the offers (scheme, network, `amountAtomic`, asset), the rail the wallet would use, the price, and whether your caps allow it. It pays nothing. For a URL that is not x402: `paymentRequired: false` and the HTTP status. |
| 6 | "pay it" | `x402_pay {url}` | `{ok, paid, requestId, transaction, scheme, amountAtomic, ...}` and the seller's answer in `body`. A large or binary answer goes to a file, and `bodyFile` names it. |
| 7 | "get that report, but pay at most 0.01 USDC" | `x402_pay {url, max_payment_atomic: "10000"}` | The same as 6. A higher price is refused before anything is signed. An argument can only lower the launch cap, never raise it. |
| 8 | "send 2 USDC to <address>" | `wallet_unshield {amount_atomic: "2000000", to: "<address>", request_id: "send-1"}` | Your client asks you first: "Send 2 USDC from your shielded balance to <address>?" (not for an `--unshield-to` address). Then a `stage` (`confirming`, `queued`, `refreshing`, `self-pay`, `exit`, `done`). At `done`: `exitTransaction` and `backupPath`. |
| 9 | "show my receipts" | `wallet_receipts {}` | `{ok, count, total, receipts}`. Each receipt has the host (never the full URL), `amountAtomic`, `transaction`, and `answeredAt`. |
| 10 | "cancel the payment that is stuck" | `wallet_cancel {request_id}` | Closes one unfinished payment so its reserved balance comes back. A payment that never left the wallet closes at once. A sent one closes only after its quote expired and the pool history shows it never landed. It pays nothing. |

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
| `mcp_session_cap_exceeded` | This server process reached `--max-session`. |
| `mcp_cap_argument_above_launch_cap` | The agent asked for a cap above the launch cap. |
| `mcp_tool_disabled` | The tool is off. `next` says which flag turns it on. |
| `mcp_unshield_declined` | You did not confirm a send (decline, cancel, or 5 minutes with no answer). Nothing was signed. |
| `mcp_unshield_to_not_allowed` | The address is the wallet's own address, or your client cannot ask you and the address is not in `--unshield-to`. |
| `fetch_offer_confidential` | The seller offers only `confidential` (hidden amounts). The MCP does not pay it. Use `shinjuku-wallet laneb pay-url`. |
| a code that ends in `_retry_same_request` | Call `x402_pay` again with the same `request_id`. It never pays twice. |
