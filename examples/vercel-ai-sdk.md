# Vercel AI SDK

The [Vercel AI SDK](https://ai-sdk.dev) reads MCP servers through
`@ai-sdk/mcp`. It runs the same `shinjuku-shield@0.3.86 mcp` server as the other
examples, so you do not need another package.

## 1. Set up the wallet in a terminal

```sh
npx -y --no-audit --no-fund shinjuku-shield@0.3.86 setup
```

Setup creates the wallet only after you confirm it. An AI SDK app does not
show that confirmation to you, so run setup once in a terminal first. If you
call `shinjuku_setup` from the app, it answers `mcp_setup_needs_terminal` and
creates nothing.

## 2. Install

```sh
npm install ai @ai-sdk/mcp
```

Also install the provider package for your model, for example
`@ai-sdk/anthropic` or `@ai-sdk/openai`.

## 3. Connect the tools

```js
import { generateText, stepCountIs } from "ai";
import { createMCPClient } from "@ai-sdk/mcp";
import { Experimental_StdioMCPTransport } from "@ai-sdk/mcp/mcp-stdio";
import { anthropic } from "@ai-sdk/anthropic";

const shinjuku = await createMCPClient({
  transport: new Experimental_StdioMCPTransport({
    command: "npx",
    args: ["-y", "--no-audit", "--no-fund", "shinjuku-shield@0.3.86", "mcp", "--max-payment", "0.05"],
  }),
});

try {
  const tools = await shinjuku.tools();
  const { text } = await generateText({
    model: anthropic("claude-sonnet-5-5"),
    tools,
    stopWhen: stepCountIs(10),
    prompt: "Show my Shinjuku balance.",
  });
  console.log(text);
} finally {
  await shinjuku.close();
}
```

- `shinjuku.tools()` returns all the server's tools: `x402_pay`,
  `wallet_balance`, `wallet_add_funds`, `wallet_unshield`, and the others. To
  give the model only some of them, pick them by name, for example
  `{ x402_pay: tools.x402_pay, wallet_balance: tools.wallet_balance }`.
- Every flag of `help mcp` goes in `args`. The caps (`--max-payment`,
  `--max-session`, `--max-unshield`) are optional and in USDC:
  `0.05` = 5 cents. With no cap there is no limit.
- Windows: if Node cannot find `npx`, use `command: "cmd"` and put `"/c",
  "npx"` at the start of `args`.
- Close the client when you are done. The server holds the wallet lease while
  it runs. Run one server per wallet at a time.

## Unshield to a new address

`wallet_unshield` to an address that you did not approve asks you to confirm
through MCP elicitation. The AI SDK client does not answer that by default,
so the call is refused and nothing is sent. Approve the address ahead of
time with `--unshield-to <address>` in `args`.

## Check that it works

Call one tool without a model:

```js
const tools = await shinjuku.tools();
const result = await tools.wallet_balance.execute({}, { toolCallId: "check", messages: [] });
console.log(result.content[0].text);
```

The answer is JSON. It holds `balanceAtomic` (1000000 = 1 USDC) and what it holds
under `breakdown`.
