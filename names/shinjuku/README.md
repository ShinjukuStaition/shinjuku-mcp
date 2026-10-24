# shinjuku

The `shinjuku` command of Shinjuku Shield: a self-custody wallet that pays
x402 URLs privately from a shielded USDC balance on Solana, and pays for AI
answers privately. This package runs the wallet package `shinjuku-shield` at
the exact version it names (the same version number as this package). Your
keys never leave your machine. The wallet package gives you the same
`shinjuku` command:

```sh
npm install -g --no-audit --no-fund shinjuku-shield@{{VERSION}}
shinjuku setup
```

Every wallet command works the same way after `shinjuku`, for example
`shinjuku balance`, `shinjuku chat` or `shinjuku help`.

Docs, host configs and the release table:
https://github.com/ShinjukuStaition/shinjuku-shield
