# Hermes Agent

Hermes Agent starts Shinjuku Shielded as a stdio MCP server. Do the setup in
[README.md](README.md) first: Node 22, the proof tools, the passphrase file,
and `init`.

Add this to your Hermes `config.yaml`. Replace `/home/you/...` with your own
absolute paths.

```yaml
mcp_servers:
  shinjuku:
    command: npx
    args:
      - "-y"
      - "shinjuku-shielded@0.1.0"
      - "mcp"
      - "--max-payment"
      - "50000"
      - "--max-session"
      - "200000"
      - "--tor"
      - "--pool"
      - "AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8"
      - "--program"
      - "8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1"
      - "--memo-service"
      - "https://pay.shinjukustaition.com"
      - "--passphrase-file"
      - "/home/you/shinjuku/passphrase.txt"
      - "--proof-tools"
      - "/home/you/shinjuku/shinjuku-proof-tools/proof-tools.json"
      - "--exit-proof-tools"
      - "/home/you/shinjuku/shinjuku-proof-tools/exit-proof-tools.json"
      - "--profile"
      - "/home/you/shinjuku/shinjuku-proof-tools/public-profile.json"
    env:
      SHIELDED_WALLET_HOME: "/home/you/.shielded-wallet"
    timeout: 600
    connect_timeout: 60
```

Then start a new chat: `hermes chat -t mcp-shinjuku`.

- `timeout: 600`. A payment, a shield, or an unshield can take minutes (the
  proof and the settle). The Hermes default is 300 s per tool call.
- `--tor`. The wallet server makes its own Tor connections. It needs a
  running Tor with `HTTPTunnelPort 127.0.0.1:9080 IsolateDestAddr` in
  `torrc`. Hermes itself needs no proxy for this server: it talks to the
  server on stdio. Remove `--tor` to run without Tor. Then the seller and our
  facilitator see your IP.
- `--max-payment` and `--max-session` are required, in atomic USDC
  (50000 = 0.05 USDC). The server does not start without them. A tool call
  can only lower them.
- A send to an address that is not in `--unshield-to` asks you to confirm.
  Hermes supports this question (MCP elicitation, on by default, `timeout`
  300 s). The wallet waits 5 minutes. No answer sends nothing.
- The passphrase comes from `--passphrase-file` (or `SHIELDED_WALLET_PASSPHRASE`
  in `env`). A tool call never takes it.

Hermes and its model provider see every URL, price, paid answer, amount, and
unshield address that the agent handles. A local model removes that
observer.

The full flag list is in [claude-code.md](claude-code.md#every-part-of-the-command).

