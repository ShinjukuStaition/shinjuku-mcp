# Hermes Agent

Hermes Agent starts Shinjuku Shielded as a stdio MCP server. You need
Node.js 22 or later, on Linux or on Windows with WSL. macOS is not
supported.

Add this to your Hermes `config.yaml`:

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

- The first time, the server has no wallet and starts in setup mode. Ask
  "what is my balance". The agent calls `shinjuku_setup`, and Hermes asks
  you to confirm that it may create a Shinjuku Shielded wallet on this
  machine (MCP elicitation, on by default). Accept, and the setup runs. Then
  the same server switches to the wallet tools. Hermes shows an Approve
  button with an empty form: Approve counts as accept.
- You can also run the setup in a terminal first:
  `npx -y shinjuku-shielded setup`.
- `timeout: 600`. A payment, a shield, or an unshield can take minutes (the
  proof and the settle). The Hermes default is 300 s per tool call.
- Tor: run the setup with `--prefer-tor`. The wallet server then makes its
  own Tor connections. It needs a running Tor with
  `HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr` in `torrc`. Hermes itself
  needs no proxy for this server: it talks to the server on stdio. Without
  Tor, the seller and our facilitator see your IP.
- Caps: setup records them in `config.json` (default 0.05 USDC per payment
  and 1 USDC per session). Add a flag such as `"--max-payment"`, `"20000"`
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
