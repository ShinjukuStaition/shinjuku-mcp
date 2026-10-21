# Claude Code

Set up Shinjuku Shielded and add it to Claude Code with one command. You
need Node.js 22.21 or later (or Node.js 24 or later), on Linux or on Windows with WSL. macOS is not
supported.

```sh
npx -y shinjuku-shielded setup --add-to claude-code
```

Setup makes the wallet, a random passphrase file, the checked proof tools
(about 191 MB), and `config.json` in `~/.carbon-shielded-wallet`. In our
runs it took about 10-16 s on a fast line. It also writes a recovery file
with the seed and the key. Copy it to two offline places, then delete it
from this machine. `--add-to claude-code` then adds the server to Claude
Code.

Without `--add-to`, setup prints the command. Run it once:

```sh
claude mcp add --scope user shinjuku-shielded -- npx -y shinjuku-shielded mcp
```

The parts of the command:

| Part | What it does |
|---|---|
| `claude mcp add shinjuku-shielded` | Adds a stdio MCP server named `shinjuku-shielded` to Claude Code. |
| `--scope user` | Makes the server available in all your projects. Without it, the scope is `local` (this project only). |
| `--` | Ends the Claude Code options. All after it is the server command. |
| `npx -y shinjuku-shielded` | Gets and runs the npm package (the newest version). Write `shinjuku-shielded@0.3.54` to pin it. |
| `mcp` | The wallet command that runs the MCP server on stdio. |

On native Windows, the printed command puts `cmd /c` before `npx`. With a
wallet folder that is not the default, it adds
`-e SHIELDED_WALLET_HOME=<home>`.

## Or: add the server first

You can also run the `claude mcp add` command before any setup. Start
Claude Code and ask "what is my balance". The server has no wallet yet, so
it starts in setup mode with two tools: `shinjuku_setup` and
`wallet_status`. Claude calls `shinjuku_setup`, and Claude Code asks you to
confirm that it may create a Shinjuku Shielded wallet on this machine, with
the caps.

- Accept: the setup runs in the background (with the proof-tool download of
  about 191 MB). Then the same server switches to the wallet tools. You do
  not restart it.
- Decline: nothing is created.

## Tor

```sh
npx -y shinjuku-shielded setup --prefer-tor
```

`--prefer-tor` records Tor in `config.json`. The server then sends every
request through Tor, and the seller and our facilitator do not see your IP.
It adds about 1-2 s per request. It needs a running Tor with this line in
`torrc`:

```
HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr
```

Without Tor, the seller sees your IP. Our facilitator
(`pay.shinjukustaition.com`, no CDN in the path) also sees your IP. It
keeps no access logs. On chain, a shielded payment does not show who paid in
both modes.

## Caps

Caps are optional. By default there is no limit: only the balance bounds a
payment. Setup records the caps you set in `config.json`. To set them, give
them to the first setup, in USDC (`0.05` = 5 cents):

```sh
npx -y shinjuku-shielded setup --max-payment 0.1 --max-session 2 --max-cumulative 50
```

When setup creates the wallet, it also writes `--max-payment` (the most one
payment may cost) and `--max-cumulative` (the most all payments may cost
together) into the wallet file. A later setup never changes the wallet file:

- It records new caps in `config.json`, and `mcp` uses them as its session
  caps. So a rerun can change `--max-payment` and `--max-session` for the
  server.
- A payment above the wallet file's own per-payment limit is still refused,
  and the lifetime total stays as it was created.
- To show, change, or remove those two limits, run
  `npx -y shinjuku-shielded limits --pool <pool>` with `--max-payment` or
  `--max-cumulative` (`none` removes a limit;
  `npx -y shinjuku-shielded help limits`).
- Money that you send to yourself or others with `wallet_unshield` does not
  count against the lifetime total.

Or add a flag to the server command. A flag wins over `config.json`:

| Flag | What it does |
|---|---|
| `--max-payment <usdc>` | Optional. The most one payment to a seller may cost, in USDC (`0.05` = 5 cents). A tool call can only lower it. Default: no limit. |
| `--max-session <usdc>` | Optional. The most this wallet may pay in any 24 hours, from every MCP process together. When you set both, it must be at least `--max-payment` (`mcp_cap_invalid`). Default: no limit. |
| `--max-per-host-day <usdc>` | The most one seller host may receive in 24 hours, in USDC. |
| `--allow-host <host>` | Pay only this seller host. Repeat it for more hosts. |
| `--ready-pockets <0-5>` | Accepted for older configs and ignored. Standard `exact` sellers are paid through Shinjuku, and no pocket is filled. |
| `--no-auto-pockets` | Accepted for older configs. It also stops the idle return of old pockets to the shielded balance. |
| `--max-shield <usdc>` | The most one `wallet_shield` call may move, and the most this wallet may shield in any 24 hours, in USDC. |
| `--no-shield` | Turns `wallet_shield` off. |
| `--unshield-to <address>` | A public Solana address that `wallet_unshield` sends to with no question. Repeat it for more. The wallet's own key is refused. |
| `--max-unshield <usdc>` | The most one `wallet_unshield` call may send, and the most this wallet may send in any 24 hours, in USDC. Without it, a send that you confirm can move the whole shielded balance. |
| `--no-tor` | This run does not use the Tor that setup recorded. |
| `--rpc-file <file>` | Your own Solana RPC URL on the first line of a private file. Without it, reads go through our relay, which sees which accounts the wallet reads. |

For example:

```sh
claude mcp add --scope user shinjuku-shielded -- npx -y shinjuku-shielded mcp --max-per-host-day 0.5
```

`npx -y shinjuku-shielded help mcp` and `npx -y shinjuku-shielded help setup`
print the full flag lists on your machine.

## A wallet from before 0.2.0

A wallet that you made with `init` has no `config.json`. Run setup once with
your wallet folder and your passphrase file. It keeps your wallet and writes
`config.json` beside it:

```sh
SHIELDED_WALLET_HOME=/home/you/.shielded-wallet \
  npx -y shinjuku-shielded setup --passphrase-file /home/you/shinjuku/passphrase.txt
claude mcp add --scope user -e SHIELDED_WALLET_HOME=/home/you/.shielded-wallet \
  shinjuku-shielded -- npx -y shinjuku-shielded mcp
```

Or give every flag yourself, as in the
[README](../README.md#advanced-flags-instead-of-configjson).

## Check that it works

1. Type `/mcp`. The list shows `shinjuku-shielded` as connected. After setup
   it has 12 tools: `wallet_balance`, `wallet_add_funds`, `x402_pay`,
   `x402_preview`, `x402_discover`, `wallet_unshield`, `wallet_cancel`,
   `wallet_receipts`, `wallet_shield`, `wallet_transfer_token`,
   `wallet_transfer_token_status`, `inference_chat`.
2. Ask: "what is my balance". Claude calls `wallet_balance`. The answer
   has `balanceAtomic` (what the agent can pay with) with its `breakdown`,
   `unshieldedAtomic` (plain USDC on the wallet's own key), `ownAddress`,
   and `status` (`"current"` when the balance is read).
3. Ask: "add 0.50 USDC to my shielded balance". Claude calls
   `wallet_add_funds`. The answer has a one-time Solana address and a
   `solana:` pay link. Send USDC to it from any wallet or exchange, from
   0.01 USDC. You need no SOL. It becomes private by itself a few minutes
   after it arrives, while the server runs.
4. A first balance on a new wallet can take some time: the server reads the
   pool history (through our facilitator's https history proxy by default,
   about 60 s for a new wallet). After about 20 s it answers the last
   balance with `refreshing: true` and finishes in the background. Ask
   again after 60 s.

If `shinjuku-shielded` shows as failed in `/mcp`, run
`npx -y shinjuku-shielded mcp` in a terminal. The server writes every log
line to stderr, and an error names what is wrong.

## Sends to a new address

`wallet_unshield` to an address that is not in `--unshield-to` asks you to
confirm in the client: "Send X USDC from your shielded balance to
<address>?". This uses MCP elicitation. If your client cannot show the
question, the send is refused (`mcp_unshield_to_not_allowed`) and nothing
moves. Then add the address with `--unshield-to` and start the server
again.

To change the server command, remove the server and add it again:

```sh
claude mcp remove shinjuku-shielded --scope user
```
