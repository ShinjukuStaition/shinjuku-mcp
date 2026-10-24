# FAQ

### Is it custodial?

No. `init` makes your Solana key and your shielded seed on your machine. We
never receive your keys, seed, passphrase, or recovery file. Our facilitator
and relayer pay network fees. They never hold your money.

Limit: with float pay, your payment for an outside seller goes to us
first, and we pay the seller from our own float. If our transfer to the
seller can no longer land, we refund price and fee to you privately.

### What does it cost?

- You pay the seller's price.
- To an outside `exact` seller (float pay), you also pay us a flat fee:
  0.001 USDC on 2026-10-11. `GET https://pay.shinjukustaition.com/api/x402/float/config`
  shows it (`feeAtomic`).
- Our facilitator pays the network fee of each payment that it settles.
- Our relayer pays the fees of relayed deposits, exits, and the step that
  gathers a balance from several deposits.
- Your own key pays when it signs: a self-broadcast deposit, MCP
  `wallet_shield` (it needs about 0.01 SOL on the wallet key), and the first
  Privacy Cash step.
- The funding route has its own costs (an exchange withdrawal fee, a
  ChangeNOW swap).

A seller whose 402 offers `shielded-exact` pays no fee to us beyond its
price.

### Which networks and tokens?

Solana mainnet only (`solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp`). The token
is USDC. `GET https://shinjukustaition.com/api/x402/supported` lists what
the facilitator serves now.

### Can you see my payments?

Our server sees what it processes: your deposits, payments, and exits, their
times, and the IP of each request (a Tor exit with `--tor`). With float pay
we also see which private payment paid which seller, the price, and the
URL, until the payment is final or refunded. We do not see your wallet. The
details for each scheme are in
[privacy-model.md](privacy-model.md).

### Do you keep logs?

Our web server removes the client IP, port, and headers from its log lines.
The RPC relay keeps no request log. Our process still sees each request in
memory while it answers it. This is a policy that you must trust. `--tor`
keeps your IP away from us.

### Why Tor?

The scheme hides you on chain. It does not hide your IP. Without Tor, our
server and the seller see your IP. With `--tor`, no single party sees both
who you are and what you request. Every request to our facilitator then goes
to its onion service. It adds about 1 to 2 seconds per request.

### Does Cloudflare see my payments?

Not on the default path. The wallet's default facilitator,
`https://pay.shinjukustaition.com`, skips Cloudflare. Our server still sees
your requests.

### Is it anonymous right now?

Only as anonymous as the crowd in the pool. Our pools are new and have few
users. With few users, time and amounts can link a deposit to a payment. When
you are the only user, waiting buys nothing. Read "Privacy needs a crowd" in
[privacy-model.md](privacy-model.md).

### How do I withdraw?

`unshield` sends some of your balance to a public Solana address. Our relayer
sends the exit and pays its fees. Use a recipient that is not your deposit
address: the command refuses the deposit key. The chain shows the amount and
the recipient. It does not show which deposit paid it.

Over MCP, `wallet_unshield` does the same. It sends at once only to an
address that you set at launch (`--unshield-to`). Any other address needs
your confirmation in the MCP client.

### What if your server goes down?

Your keys, seed, and wallet file stay on your machine. `recover` rebuilds
your notes from your seed, the public chain history, and the encrypted
memos. The wallet logs each step that moves value before it sends it. After
an interruption, run the same command again.

Limit: payments, relayed deposits, and exits use our facilitator and
relayer. Our docs describe no exit path that works without our server.

### What if I lose my keys?

`restore` rebuilds the wallet from the recovery file that `init` wrote. Keep
that file in two offline places. If you lose both the seed and the recovery
file, your funds are lost. We cannot recover them.

### Is it audited?

No. No independent audit of the circuits, the verifiers, or the binding has
run. The proving keys came from single-operator setups. No multi-party
ceremony has run.

### Can my AI agent spend all my money?

Not past the caps you set. Caps are optional: by default there is no limit,
and only the balance bounds a payment. Set `--max-payment` and
`--max-session` (or give them to setup) to limit it. A tool call can only
lower a cap. `--allow-host` limits which sellers it pays. Caps in the
wallet file itself (`init --max-payment`, `--max-cumulative`) change with
`shinjuku-wallet limits` (`none` removes a cap).

Limits: without `--max-unshield`, a confirmed unshield can move the whole
shielded balance. The MCP host and its model provider see every URL, body,
price, and paid answer. A local model removes that observer.

### Can I sell?

Yes. Keep your standard x402 `exact` middleware on your current
facilitator (Coinbase CDP, PayAI, or any other). Shinjuku Shield buyers
pay you through float pay, and you change nothing:
[sell-with-shinjuku.md](sell-with-shinjuku.md). Selling `shielded-exact`
needs our source repository, which is not public yet. Hidden-amount selling
(scheme `confidential`) is retired.

### How do I know the wallet file is ours?

Check its SHA-256 against two places: our website and the Releases table in
this repository. A match proves that your copy is complete and equals the
published file. It does not prove who made the file. Each release builds
reproducibly: two independent builds give the same SHA-256.

### Why does a payment say the balance is split?

One payment spends one piece plus at most 3 notes. Each deposit is its own
piece. When no single piece covers the price, the wallet gathers the pieces
inside the pool: the MCP server does it by itself, and in a terminal
`shinjuku-shield help` names the command. Our relayer pays every fee. Wait
for the next pool anchor (usually within a minute), then pay again.

### Which operating systems?

The wallet file runs on Node.js 22 or later. The provers that the money
commands need are Linux x86-64 programs. On Windows, run them through WSL.
macOS is not supported.
