# Claude Code

Add Shinjuku Shielded to Claude Code with one command. Do the setup in
[README.md](README.md) first: Node 22, the proof tools, the passphrase file,
and `init`.

Replace `/home/you/...` with your own absolute paths. Claude Code starts the
server from its own folder, so a relative path does not work.

## With Tor (recommended)

```sh
claude mcp add shinjuku -s user \
  -e SHIELDED_WALLET_HOME=/home/you/.shielded-wallet \
  -- npx -y shinjuku-shielded@0.1.0 mcp \
  --max-payment 50000 --max-session 200000 \
  --tor \
  --pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8 \
  --program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1 \
  --memo-service https://pay.shinjukustaition.com \
  --passphrase-file /home/you/shinjuku/passphrase.txt \
  --proof-tools /home/you/shinjuku/shinjuku-proof-tools/proof-tools.json \
  --exit-proof-tools /home/you/shinjuku/shinjuku-proof-tools/exit-proof-tools.json \
  --profile /home/you/shinjuku/shinjuku-proof-tools/public-profile.json
```

`--tor` needs a running Tor with this line in `torrc`:

```
HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr
```

The server checks that Tor works before its first request. With `--tor`,
the seller and our facilitator do not see your IP. It adds about 1-2 s per
request.

## Without Tor

The same command without `--tor`:

```sh
claude mcp add shinjuku -s user \
  -e SHIELDED_WALLET_HOME=/home/you/.shielded-wallet \
  -- npx -y shinjuku-shielded@0.1.0 mcp \
  --max-payment 50000 --max-session 200000 \
  --pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8 \
  --program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1 \
  --memo-service https://pay.shinjukustaition.com \
  --passphrase-file /home/you/shinjuku/passphrase.txt \
  --proof-tools /home/you/shinjuku/shinjuku-proof-tools/proof-tools.json \
  --exit-proof-tools /home/you/shinjuku/shinjuku-proof-tools/exit-proof-tools.json \
  --profile /home/you/shinjuku/shinjuku-proof-tools/public-profile.json
```

Without Tor, the seller sees your IP. Our facilitator
(`pay.shinjukustaition.com`, no CDN in the path) also sees your IP. It
keeps no access logs. On chain, a shielded payment does not show who paid in
both modes.

## Every part of the command

| Part | Required | What it does |
|---|---|---|
| `claude mcp add shinjuku` | yes | Adds a stdio MCP server named `shinjuku` to Claude Code. |
| `-s user` | no | Makes the server available in all your projects. Without it, the scope is `local` (this project only). |
| `-e SHIELDED_WALLET_HOME=...` | yes, in practice | The private folder that holds the encrypted wallet. Use the same folder that `init` used. |
| `--` | yes | Ends the Claude Code options. All after it is the server command. |
| `npx -y shinjuku-shielded@0.1.0` | yes | Gets and runs the npm package. `@0.1.0` pins the version, so each start runs the same wallet file (release `1a336885`). |
| `mcp` | yes | The wallet command that runs the MCP server on stdio. |
| `--max-payment 50000` | yes | The most one payment to a seller may cost, in atomic USDC (50000 = 0.05 USDC). Without it, the server does not start (`mcp_cap_required`). A tool call can only lower it. |
| `--max-session 200000` | yes | The most this server process may pay in total (200000 = 0.20 USDC). It must be at least `--max-payment` (`mcp_cap_invalid`). |
| `--tor` | no | Sends every request through Tor. Our facilitator is then reached on its onion service. Needs `HTTPTunnelPort 127.0.0.1:9080` in `torrc`. |
| `--pool AAG16m...` | yes (or `--wallet <file>`) | The production shielded pool. The wallet file is `$SHIELDED_WALLET_HOME/<pool>/wallet.json`. |
| `--program 8PYPw3...` | yes | The shielded pool program on Solana mainnet. |
| `--memo-service https://pay.shinjukustaition.com` | yes | Our facilitator. It serves the encrypted memos, and its RPC relay serves the chain reads when you give no `--rpc-file`. |
| `--passphrase-file <file>` | yes, or the env variable | A private file with the wallet passphrase. Without it, the server reads `SHIELDED_WALLET_PASSPHRASE`. A tool call never takes the passphrase. |
| `--proof-tools <file>` | for shielded payments and shield | The public proof-tools manifest. It turns `wallet_shield` on, and it is needed to pay `shielded-exact`. |
| `--exit-proof-tools <file>` | for unshield | With `--profile` and `--proof-tools`, turns `wallet_unshield` on. |
| `--profile <file>` | for unshield | The facilitator's public seller profile, `public-profile.json`. |

Optional flags that you can add:

| Flag | What it does |
|---|---|
| `--max-per-host-day <atomic>` | The most one seller host may receive in 24 hours. |
| `--allow-host <host>` | Pay only this seller host. Repeat it for more hosts. |
| `--max-shield <atomic>` | The most one `wallet_shield` call, and this process in total, may move. |
| `--no-shield` | Turns `wallet_shield` off. |
| `--unshield-to <address>` | A public Solana address that `wallet_unshield` sends to with no question. Repeat it for more. The wallet's own key is refused. |
| `--max-unshield <atomic>` | The most one `wallet_unshield` call, and this process in total, may send. Without it, a send that you confirm can move the whole shielded balance. |
| `--rpc-file <file>` | Your own Solana RPC URL on the first line of a private file. Without it, reads go through our relay, which sees which accounts the wallet reads. |

`node shinjuku-wallet.mjs help mcp` (or `npx -y shinjuku-shielded@0.1.0 help mcp`)
prints the full flag list on your machine.

## Check that it works

1. Start Claude Code and type `/mcp`. The list shows `shinjuku` as
   connected, with 7 tools: `x402_preview`, `x402_pay`, `wallet_balance`,
   `wallet_receipts`, `wallet_cancel`, `wallet_shield`, `wallet_unshield`.
2. Ask: "what is my shielded balance". Claude calls `wallet_balance`. The
   answer has `shieldedAtomic` (what the agent can pay with),
   `unshieldedAtomic` (plain USDC on the wallet's own key), `ownAddress`,
   and `session` (the caps and what this process may still pay).
3. A first balance on a new wallet can take some time: the server reads the
   pool history from the chain. After about 20 s it answers the last balance
   with `refreshing: true` and finishes in the background. Ask again after
   30 s.

If `shinjuku` shows as failed in `/mcp`, run the same command in a terminal
(the part after `--`). The server writes every log line to stderr, and a
setup error names the flag that is wrong.

## Sends to a new address

`wallet_unshield` to an address that is not in `--unshield-to` asks you to
confirm in the client: "Send X USDC from your shielded balance to
<address>?". This uses MCP elicitation. If your client cannot show the
question, the send is refused (`mcp_unshield_to_not_allowed`) and nothing
moves. Then add the address with `--unshield-to` and start the server
again.

To change a flag, remove the server and add it again:

```sh
claude mcp remove shinjuku -s user
```
