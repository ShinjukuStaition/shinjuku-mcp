# Claude Code

Add Shinjuku Shielded to Claude Code with one command. You need Node.js 22
or later, on Linux or on Windows with WSL. macOS is not supported.

```sh
claude mcp add --scope user shinjuku-shielded -- npx -y shinjuku-shielded mcp
```

| Part | What it does |
|---|---|
| `claude mcp add shinjuku-shielded` | Adds a stdio MCP server named `shinjuku-shielded` to Claude Code. |
| `--scope user` | Makes the server available in all your projects. Without it, the scope is `local` (this project only). |
| `--` | Ends the Claude Code options. All after it is the server command. |
| `npx -y shinjuku-shielded` | Gets and runs the npm package (the newest version). Write `shinjuku-shielded@0.3.1` to pin it. |
| `mcp` | The wallet command that runs the MCP server on stdio. |

## The first start

Start Claude Code and ask "what is my balance". The server has no wallet
yet, so it starts in setup mode with two tools: `shinjuku_setup` and
`wallet_status`. Claude calls `shinjuku_setup`, and Claude Code asks you to
confirm that it may create a Shinjuku Shielded wallet on this machine, with
the caps.

- Accept: the setup runs in the background (about 25 s in our test, with
  the proof-tool download of about 150 MB). Then the same server switches
  to the wallet tools. You do not restart it.
- Decline: nothing is created.

Setup writes the wallet, a random passphrase file, the checked proof tools,
and `config.json` to `~/.carbon-shielded-wallet`. It also writes a recovery
file with the seed and the key. Copy it to two offline places, then delete
it from this machine.

You can also run the setup in a terminal first. This form also adds the
server to Claude Code:

```sh
npx -y shinjuku-shielded setup --add-to claude-code
```

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

Setup records the caps in `config.json`. The defaults are 0.05 USDC per
payment, 1 USDC per session, and 20 USDC for the life of the wallet. To pick
your own, give them to the first setup (in atomic USDC: `50000` = 0.05 USDC):

```sh
npx -y shinjuku-shielded setup --max-payment 100000 --max-session 2000000 --max-total 50000000
```

When setup creates the wallet, it also writes `--max-payment` (the most one
payment may cost) and `--max-total` (the most all payments may cost
together) into the wallet file. A later setup never changes the wallet file:

- It records new caps in `config.json`, and `mcp` uses them as its session
  caps. So a rerun can change `--max-payment` and `--max-session` for the
  server.
- A payment above the wallet file's own per-payment limit is still refused,
  and the lifetime total stays as it was created.
- To raise those two limits, restore the recovery file into a new wallet
  home with higher `--max-payment` and `--max-cumulative`
  (`npx -y shinjuku-shielded help restore`).
- Money that you send to yourself or others with `wallet_unshield` does not
  count against the lifetime total.

Or add a flag to the server command. A flag wins over `config.json`:

| Flag | What it does |
|---|---|
| `--max-payment <atomic>` | The most one payment to a seller may cost. A tool call can only lower it. |
| `--max-session <atomic>` | The most this server process may pay in total. It must be at least `--max-payment` (`mcp_cap_invalid`). |
| `--max-per-host-day <atomic>` | The most one seller host may receive in 24 hours. |
| `--allow-host <host>` | Pay only this seller host. Repeat it for more hosts. |
| `--ready-pockets <0-5>` | How many 1 USDC pockets stay ready for standard `exact` sellers. Default 1. |
| `--no-auto-pockets` | `x402_pay` does not fill a pocket by itself. |
| `--max-shield <atomic>` | The most one `wallet_shield` call, and this process in total, may move. |
| `--no-shield` | Turns `wallet_shield` off. |
| `--unshield-to <address>` | A public Solana address that `wallet_unshield` sends to with no question. Repeat it for more. The wallet's own key is refused. |
| `--max-unshield <atomic>` | The most one `wallet_unshield` call, and this process in total, may send. Without it, a send that you confirm can move the whole shielded balance. |
| `--no-tor` | This run does not use the Tor that setup recorded. |
| `--rpc-file <file>` | Your own Solana RPC URL on the first line of a private file. Without it, reads go through our relay, which sees which accounts the wallet reads. |

For example:

```sh
claude mcp add --scope user shinjuku-shielded -- npx -y shinjuku-shielded mcp --max-per-host-day 500000
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
   it has 9 tools: `x402_discover`, `x402_preview`, `x402_pay`, `wallet_balance`,
   `wallet_receipts`, `wallet_cancel`, `wallet_shield`, `wallet_unshield`,
   `wallet_shield_from_elsewhere`.
2. Ask: "what is my shielded balance". Claude calls `wallet_balance`. The
   answer has `shieldedAtomic` (what the agent can pay with),
   `unshieldedAtomic` (plain USDC on the wallet's own key), `ownAddress`,
   and `session` (the caps and what this process may still pay).
3. A first balance on a new wallet can take some time: the server reads the
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
