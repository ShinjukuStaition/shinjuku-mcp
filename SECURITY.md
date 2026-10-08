# Security

## Report a vulnerability

Report it privately on GitHub: open the **Security** tab of this repository
and select **Report a vulnerability**
(https://github.com/ShinjukuStaition/shinjuku-mcp/security/advisories/new).
Only the maintainers see the report.

Do not open a public issue for a vulnerability. Do not put a private key, a
recovery file, or a passphrase in a report. We never ask for them.

Please include:

- the wallet release (`npx -y shinjuku-shielded help` and the npm version, or
  the SHA-256 of `shinjuku-wallet.mjs`),
- your MCP client and its version,
- the steps that show the problem, and what you expected.

## In scope

The behavior of the MCP server (`shinjuku-wallet mcp`, also run as
`npx shinjuku-shielded mcp`), for example:

- a payment above `--max-payment`, `--max-session`, `--max-per-host-day`, or
  outside `--allow-host`;
- a tool argument that raises a cap;
- a payment, a shield, or a send that happens twice for the same
  `request_id`;
- a send to an address that is not in `--unshield-to` and that you did not
  confirm, or a send to the wallet's own key;
- a key, a seed, or the passphrase in a tool answer, in stdout, or in a log;
- a tool that works while it should be off (`mcp_tool_disabled`);
- `--tor` traffic that leaves outside Tor;
- the configs and commands in this repository and in `examples/`.

## Out of scope

- A malicious or modified MCP client app. The client app shows the send
  confirmation. A client that answers "accept" by itself can approve a send.
  For a strict setup, use `--unshield-to` and a client without elicitation.
- What your agent host and its model provider see: every URL, price, paid
  answer, amount, and send address that the agent handles.
- Public on-chain facts: a shield shows the wallet's own key, the amount,
  and the time; a send shows the amount, the receiving address, and the
  time.
- Timing links when the pool has few users.

## Self-custody

The wallet runs on your machine. Your keys and your passphrase stay in the
wallet process. We never hold your keys or your money, so we cannot move,
freeze, or recover your funds. Keep the recovery file that `init` wrote in
two offline places. If you think a key is exposed, move your funds to a new
wallet.

Check the wallet file before you run it: its SHA-256 is in the
[Releases table](https://github.com/ShinjukuStaition/shinjuku-shielded#releases)
and in section 7b of https://shinjukustaition.com/skill.md. A match proves
that your copy is complete, not who made it.
