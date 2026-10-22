# Hermes Agent

Hermes Agent starts Shinjuku Shielded as a stdio MCP server. You need
Node.js 22.21 or later (or Node.js 24 or later), on Linux or on Windows with WSL. macOS is not
supported.

First, run the setup in a terminal:

```sh
npx -y --no-audit --no-fund shinjuku-shielded setup
```

It makes the wallet, a random passphrase file, the checked proof tools
(about 191 MB), and `config.json`. It also writes a recovery file: copy it
to two offline places, then delete it from this machine.

Then add this to your Hermes `config.yaml`:

```yaml
mcp_servers:
  shinjuku:
    command: npx
    args:
      - "-y"
      - "shinjuku-shielded"
      - "mcp"
    timeout: 600
    connect_timeout: 60
```

Then start a new chat: `hermes chat -t mcp-shinjuku`.

- Add funds: ask "add 0.50 USDC to my shielded balance". The agent calls
  `wallet_add_funds` and gives a one-time address. Send USDC to it from any
  wallet or exchange, from 0.01 USDC. You need no SOL.
- Without a terminal setup, the server has no wallet and starts in setup
  mode. Ask "what is my balance". The agent calls `shinjuku_setup`, and
  Hermes asks you to confirm that it may create a Shinjuku Shielded wallet
  on this machine (MCP elicitation, on by default). Accept, and the setup
  runs. Then the same server switches to the wallet tools. Hermes shows an
  Approve button with an empty form: Approve counts as accept.
- `timeout: 600`. A payment, a shield, or an unshield can take minutes (the
  proof and the settle). The Hermes default is 300 s per tool call.
- Tor: run the setup with `--prefer-tor`. The wallet server then makes its
  own Tor connections. It needs a running Tor with
  `HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr` in `torrc`. Hermes itself
  needs no proxy for this server: it talks to the server on stdio. Without
  Tor, the seller and our facilitator see your IP.
- Caps: optional; by default there is no limit. Setup records the caps you
  set in `config.json`. Add a flag such as `"--max-payment"`, `"20000"`
  after `"mcp"` to change one for this server. A tool call can only lower
  them.
- A send to an address that is not in `--unshield-to` asks you to confirm.
  Hermes supports this question (`timeout` 300 s). The wallet waits 5
  minutes. No answer sends nothing.
- The passphrase is in the private file that setup made. A tool call never
  takes it.
- A wallet in another folder: add `env:` with
  `SHIELDED_WALLET_HOME: "/home/you/.shielded-wallet"`.

Hermes and its model provider see every URL, price, paid answer, amount, and
unshield address that the agent handles. A local model removes that
observer.

The full flag list is in [claude-code.md](claude-code.md#caps).
