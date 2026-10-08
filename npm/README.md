# shinjuku-shielded

The Shinjuku Shielded wallet: a self-custody command-line wallet for the
Shinjuku Shielded private x402 facilitator on Solana. Its `mcp` command runs a
local MCP server (stdio) that lets an agent pay x402 URLs from your shielded
USDC balance, under caps that you set at launch.

This package holds one wallet release, unchanged. The `shinjukuRelease` and
`shinjukuSha256` fields in `package.json` name that release. Compare the hash
with the Releases table in
[ShinjukuStaition/shinjuku-shielded](https://github.com/ShinjukuStaition/shinjuku-shielded#releases).
Each version holds one served wallet release, byte for byte: `shinjukuRelease` and `shinjukuSha256` in package.json name it, and its SHA-256 is in the Releases table of ShinjukuStaition/shinjuku-shielded. From 0.1.1 on, versions are published from GitHub Actions with npm provenance.

Needs Node.js 22 or later. The package has no install scripts.

## Run

```sh
npx -y shinjuku-shielded@<version> help
npx -y shinjuku-shielded@<version> help mcp
```

Or install it once: `npm install -g shinjuku-shielded`. This gives the
commands `shinjuku-shielded` and `shinjuku-wallet`.

Pin the version in your agent config, so that each start runs the same file.

## Add the MCP server

Set up the wallet first (passphrase, deposit, `rpc.txt`, `proof-tools.json`).
The full setup guide is
[ShinjukuStaition/shinjuku-mcp](https://github.com/ShinjukuStaition/shinjuku-mcp).
`--max-payment` and `--max-session` are required, in atomic USDC units
(50000 = 0.05 USDC). An MCP host starts the server from its own folder: use
absolute paths.

Claude Code:

```sh
claude mcp add shinjuku-pay -- npx -y shinjuku-shielded@<version> mcp \
  --max-payment 50000 --max-session 200000 --tor \
  --pool AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8 \
  --passphrase-file /home/you/shinjuku/passphrase.txt \
  --rpc-file /home/you/shinjuku/rpc.txt \
  --proof-tools /home/you/shinjuku/proof-tools.json \
  --program 8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1 \
  --memo-service https://pay.shinjukustaition.com
```

Claude Desktop (`claude_desktop_config.json`) and Cursor (`.cursor/mcp.json`
or `~/.cursor/mcp.json`) use the same JSON:

```json
{
  "mcpServers": {
    "shinjuku-pay": {
      "command": "npx",
      "args": [
        "-y", "shinjuku-shielded@<version>", "mcp",
        "--max-payment", "50000", "--max-session", "200000", "--tor",
        "--pool", "AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8",
        "--passphrase-file", "/home/you/shinjuku/passphrase.txt",
        "--rpc-file", "/home/you/shinjuku/rpc.txt",
        "--proof-tools", "/home/you/shinjuku/proof-tools.json",
        "--program", "8PYPw3FSFTMbvSneXdcoH6jNoN4VD23nHwPY2A2riUy1",
        "--memo-service", "https://pay.shinjukustaition.com"
      ],
      "env": { "SHIELDED_WALLET_HOME": "/home/you/.shielded-wallet" }
    }
  }
}
```

On Windows, write paths as `C:/Users/you/...`. If the host cannot find
`npx`, use `"command": "cmd", "args": ["/c", "npx", ...]`.

`node_modules/.bin` and the global npm folder must not be writable by other
users: the MCP server holds your wallet keys.

## Proof tools

The proof tools are not in this package. Download them separately and check
their hashes, as `https://shinjukustaition.com/skill.md` section 7b tells you.
The provers are Linux programs: use Linux, or WSL on Windows. macOS is not
supported for proofs.

## License

`LICENSE.txt` (Shinjuku Shielded wallet, all rights reserved) and
`THIRD_PARTY_NOTICES.txt` (the open-source packages inside the file) ship
unchanged from the release. `manifest.json` names the source commit and every
bundled package.
