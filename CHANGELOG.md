# Changelog

The Shinjuku Shielded MCP server is the `mcp` command of the wallet file
`shinjuku-wallet.mjs`. Each wallet release has its SHA-256 in the
[Releases table](https://github.com/ShinjukuStaition/shinjuku-shielded#releases)
of `ShinjukuStaition/shinjuku-shielded`. Dates are UTC.

## 2026-10-23: npm `shinjuku-shielded@0.3.86` is the stable version (wallet release `b650bf06`, pinned)

The stable version is now 0.3.86, on npm under the tag `latest` as
`shinjuku-shielded`, `shinjuku-shield` and the `shinjuku` command. It
replaces 0.3.80 (wallet release `98296ff0`). The wallet file is the file of
the 0.3.86 candidate below. To move from an older version, run
`npx -y --no-audit --no-fund shinjuku@0.3.86 setup` once and put
`shinjuku-shield@0.3.86` in your host's MCP entry. Your wallet, its address
and its balance stay the same. How to use each feature: the
[0.3.86 release notes](README.md#release-0386).

Every feature passed a live run on the published 0.3.86 package, on
production, with real USDC, on 2026-10-23:

- Add funds (`wallet_add_funds`, `shinjuku add-funds`): 1 USDC sent at
  21:54:31 UTC was private by 21:56:55 UTC, after the agent app had closed.
- Make public USDC private (`wallet_shield`): 0.01 USDC private in one 34 s
  agent turn.
- Send any token privately (`wallet_transfer_token`): 0.132573 JUP sold;
  0.04 USDC arrived in 2 parts (22:10:51 and 22:24:32 UTC).
- Pay any x402 endpoint (`x402_pay`, `shinjuku pay`, `shinjuku curl`): the
  first payment to sellers the wallet never paid took 4.85 s and 11.31 s
  direct, 9.94 s and 18.14 s over Tor.
- Price preview (`x402_preview`): the price and the fee in 2.9 s, nothing
  paid.
- Find paid APIs (`x402_discover`): 15 paid APIs in 0.75 s.
- Automatic refunds: two failed sellers refunded in full; one seller that
  kept the money is named in the receipt.
- Slow sellers, never paid twice: sellers that answer after 30 s and 60 s,
  one payment each, and the data arrived.
- Images and files: a 1,797-byte PNG saved for 0.002 USDC.
- Cancel (`wallet_cancel`, `shinjuku cancel`): an unknown request and a paid
  one both answered correctly; nothing changed.
- Send to an address (`wallet_unshield`, `shinjuku unshield`): 0.974 USDC in
  one 48 s agent turn; 1 USDC from the terminal in 49 s.
- Send in parts at random times: 2 parts landed at 22:03:52 and 22:06:04 UTC,
  after the app had closed.
- Automatic join: 3 parts joined and sent in one call; 2 parts joined in one
  terminal command (106 s).
- Spend a received payment: a direct exit and a change exit, one transaction
  each.
- Balance (`wallet_balance`, `shinjuku balance`): answered in every run.
- Receipts (`wallet_receipts`): 6 receipts with both refunds and their
  transactions; the totals are right.
- Spending limits (`--max-payment`, `--max-session`, `shinjuku limits`): a
  0.011 USDC payment refused under a 0.001 USDC limit, nothing paid.
- Version pin and update notice: no false update notice in 11 answers.
- Ask an AI model (`inference_chat`): an answer for 0.001136 USDC in 15.1 s.
- Terminal chat (`shinjuku chat`): two answers with the context kept,
  0.002539 USDC in all.
- One question (`shinjuku infer`): both forms answered, 0.001266 USDC.
- Private AI address for your apps (`shinjuku infer start`,
  `inference_server`): the official OpenAI client streamed an answer; no
  prompt words in any log.
- Tor (`setup --tor`, `--tor`, `--no-tor`): every run of this release ran
  over Tor.
- Self-custody (`shinjuku setup`, `backup-export`): setup took 89 s; 5 min
  over Tor with the full proof download.
- The shinjuku command (`npm i -g shinjuku@0.3.86`): setup, add-funds,
  balance and send-all passed in a real terminal.

Known issues (none of them loses money; each one gets its own fix release,
tested live before the next):

1. When a seller fails before it takes the money, the answer starts with
   "Paid". The money is not taken and comes back by itself.
2. The terminal send prints one internal line that starts with
   `SELLER_STORE`.
3. `shinjuku chat` can print raw Tor lines while Tor is slow.
4. When the spending limit comes from the host's MCP entry, the refusal names
   setup as the place to change it.
5. Before a send that must first join parts, the agent may not tell you it
   takes about 2 minutes.
6. In a terminal, balance, infer and unshield print internal Tor, RPC and
   history lines.
7. A plain `shinjuku balance` right after a deposit can show no number.
   `shinjuku balance --refresh` shows it.
## 2026-10-23: wallet release `b650bf06`, npm `shinjuku-shield@0.3.86` (candidate, npm tag `next`)

A candidate: npm publishes it under the tag `next`. The stable version stays
`0.3.80` (wallet release `98296ff0`, npm tag `latest`) until we name a new
one. To try the candidate, install its exact version.

- Unshield: when the facilitator answers that its exit transaction has not
  landed yet, the wallet sends the same exit again by itself (it never sends
  twice). When the exit proof's time window ends first, the wallet makes a
  new proof once and sends it. Every refusal of the exit relay now says what
  it means and what to run.
- `shinjuku unshield --amount all --unshield-id <id>` finishes an unshield
  that started earlier, with the amount it started with. `shinjuku balance`
  names an unshield that has not finished and the command that finishes it.
- `inference_chat`: a refusal for a low `max_payment` says that the cap is
  only a limit, not the price, and what the call pays.
- A run through Tor or a proxy no longer prints Node's proxy warning many
  times.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `654041bc`, npm `shinjuku-shield@0.3.85` (candidate, npm tag `next`)

A candidate: npm publishes it under the tag `next`. The stable version stays
`0.3.80` (wallet release `98296ff0`, npm tag `latest`) until we name a new
one. To try the candidate, install its exact version.

- `shinjuku unshield --amount all --to <wallet address>` sends a balance
  held in several parts in one command: it says how long the join takes,
  joins the parts, then sends all of it. No `merge` command first.
- `shinjuku add-funds`: when the answer to a deposit is lost on the way,
  the wallet finds the deposit on the chain and finishes it. Each new try
  prints one line that says what it waits for and when it tries again.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `b73f57e5`, npm `shinjuku-shield@0.3.84` (candidate, npm tag `next`)

A candidate: npm publishes it under the tag `next`. The stable version stays
`0.3.80` (wallet release `98296ff0`, npm tag `latest`) until we name a new
one. To try the candidate, install its exact version.

- A payment stopped by the `max_payment` of that one call now says so, and
  names the amount that would work. It no longer tells you to run setup.
  The private AI chat names the smallest `max_payment` it accepts.
- Asking again for a send that already finished answers "already sent",
  with how long ago it finished. Nothing is sent twice.
- A balance check while the wallet still reads the chain shows the last
  full balance and how old it is. A history read over Tor waits for the
  onion route before its time limit starts.
- The wallet keeps the payment notes it already read, so the next start
  reads less from the chain.
- A balance held in several parts: your agent says how long the join takes
  BEFORE it starts a send of all of it.
- `shinjuku unshield --amount <usdc|all> --to <wallet address>` is the whole
  command after `shinjuku setup`. It prints plain lines and your new private
  balance (`--json` prints JSON). `shinjuku balance` prints one line.
- Every `shinjuku` command uses Tor when setup chose Tor. `--no-tor` turns
  it off for one command. The Node warning about the proxy is gone.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `a59aa27b`, npm `shinjuku-shield@0.3.83` (candidate, npm tag `next`)

A candidate: npm publishes it under the tag `next`. The stable version stays
`0.3.80` (wallet release `98296ff0`, npm tag `latest`) until we name a new
one. To try the candidate, install its exact version.

- A payment that the seller kept is no longer reported as a refund on its
  way, also when the seller refused a late retry, and the balance no longer
  counts such a refund.
- Receipts name each refund step in plain words and agree with the balance.
- A balance held in several parts: before a send of all of it, your agent
  can tell you how long the wallet needs to join the parts, and the answer
  says why the send took that long. The answer comes as soon as the send is
  final.
- A new send while a private send in parts is open no longer stops right
  after a deposit: the wallet reads its history again and goes on.
- `shinjuku add-funds` in a terminal shows one line per step and a short
  summary. `--verbose` shows every progress line, and `--json` prints the
  status as JSON (also for `shinjuku funds-status`).
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `eaf7063e`, npm `shinjuku-shield@0.3.82` (candidate, npm tag `next`)

A candidate: npm publishes it under the tag `next`. The stable version stays
`0.3.80` (wallet release `98296ff0`, npm tag `latest`) until we name a new
one. To try the candidate, install its exact version.

- A seller that writes its own URL in another encoding (for example `%2C`
  for a comma) can now be paid.
- `x402_discover` answers within about 10 s. A list that is still
  downloading is searched in its older copy or in the pages downloaded so
  far, and a later search goes on from those pages.
- After you send USDC to an add-funds address, ask for your balance once:
  the wallet then makes it private by itself.
- Receipts list a deposit made with `shinjuku add-funds`.
- The balance counts every refund on its way.
- A token transfer or a private send in parts goes on by itself when
  another wallet process holds the wallet for a moment.
- Clearer answers when a seller cannot receive a payment, when a seller
  refuses after it was paid, and for a refund on its way.
- `shinjuku infer "your question"` needs no flags after setup.
  `shinjuku chat` shows one line about Tor and no progress lines
  (`--verbose` shows them). `shinjuku add-funds` and
  `shinjuku funds-status` end with a short summary in a terminal.
- The local AI address serves the OpenAI Chat Completions API and
  `/v1/models`. Apps that use the OpenAI Responses API do not work with it
  yet.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `63f08b62`, npm `shinjuku-shield@0.3.81` (candidate, npm tag `next`)

A candidate: npm publishes it under the tag `next`. The stable version stays
`0.3.80` (wallet release `98296ff0`, npm tag `latest`) until we name a new
one. To try the candidate, install its exact version.

- Shinjuku Shield is the main name. The npm package `shinjuku-shield` holds
  the same files as `shinjuku-shielded`, and the npm package `shinjuku`
  gives the short command `shinjuku` at the same version
  (`npm install -g shinjuku@0.3.81`).
- Private AI in the terminal: `shinjuku chat`. Each answer is paid from the
  shielded balance, through Tor, with a cap of 0.05 USDC an answer and
  1 USDC a chat by default. The wallet keeps no copy of the conversation.
- A local AI address for an agent app that speaks the OpenAI API:
  `shinjuku infer start` prints the `base_url` and an api key. The address
  keeps running after the terminal closes; `shinjuku infer status` shows it
  and `shinjuku infer stop` stops it. Answers can stream (`stream: true`).
- New MCP tool `inference_server`: your agent starts, checks or stops that
  address. Its caps are never above the caps of setup or of the MCP launch.
- A private AI call is paid only in a way that keeps no copy of its request.
- A pay right after a part of a private send goes through.
- A private send in parts also finishes when the host closes all its child
  processes as it ends (Windows).
- A deposit made in a host that ends the wallet after each answer goes on
  in the background.
- The shield receipt says when the shield is done.
- `help` prints the real version, and `shinjuku` alone opens with a short
  animation in a real terminal (any key skips it).
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `98296ff0`, npm `shinjuku-shielded@0.3.80`

- A private send in parts now finishes in every agent host. In a host
  that ends the wallet after each answer (such as `claude -p`), a small
  background wallet process sends each part at its planned time, then
  ends. The agent does not need to ask again in a loop.
- `wallet_receipts` shows each part of a private send and the minutes
  until the next part goes, and lists token transfers.
- A payment the seller served shows the transfer to the seller, also when
  the seller sends no receipt header.
- A refund that has landed leaves the "on its way" balance at once.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `2b67ac65`, npm `shinjuku-shielded@0.3.79`

- A seller that takes the payment and then refuses the data: the wallet
  resends the same proof once, then says the seller keeps it. It never
  shows a refund that will not come.
- A seller that answers an error: the answer says so, and says that the
  money comes back by itself if the transfer to the seller never lands.
- `wallet_receipts` lists a payment the seller has not served yet, with
  the seller and the state of its refund.
- A seller that is not x402 v2 gets a clear refusal; nothing is paid.
- The add-funds answer gives the new balance, and the balance answer names
  all the USDC you added.
- Write `version` to print the version.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `b840ab22`, npm `shinjuku-shielded@0.3.78`

- `wallet_receipts` shows the private transaction of every payment, also
  when the app ended the wallet right after the payment.
- A token transfer reports its progress in fewer, slower answers, names the
  exact SOL it needs, and sends a total rounded down to 0.01 USDC. The rest
  stays in your private balance, so the parts do not match the sale.
- A balance split into parts joins by itself across sessions, and the
  balance answer says when a send of everything must join parts first.
- Limit refusals say how to raise the limit, and where.
- Each payment, shield or send answer gives your new balance, and "show my
  wallet" gives a short wallet card.
- `npx -y --no-audit --no-fund shinjuku-shielded version` prints the
  version (in that line npm answers `--version` itself), and MCP apps show
  the real version.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `e2b3bd72`, npm `shinjuku-shielded@0.3.77`

- While new USDC waits out its random privacy wait, the wallet tells you
  when to ask about your balance again. That ask starts the deposit if it
  has not started yet. It no longer says "no step from you".
- When the wallet stops a payment before it pays (for example over your
  limit), Shinjuku's server gets no request for that payment.
- The first payment reads the pool history checks sooner, and the wallet
  keeps each pool's name on disk, so a new session skips one read.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `6d58045e`, npm `shinjuku-shielded@0.3.76`

- A payment to a seller whose price names an old Solana blockhash no
  longer fails: when that blockhash is about to expire, the wallet signs
  with a fresh one.
- While the wallet reads a long pool history, it still answers your other
  requests (the read runs in small steps).
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-23: wallet release `57e0bc6a`, npm `shinjuku-shielded@0.3.75`

- When a paid request fails after the money left, the refund is visible:
  the answer names the refund, `wallet_receipts` says "refund pending"
  until the money is back in the balance, and the balance says how much of
  it is a refund on its way.
- `wallet_balance` right after a payment answers at once with the new
  number.
- Closing the MCP no longer waits for background work that did not start.
- With `--tor`, every command uses the Tor setup the wallet recorded.
- Setup's background read of the pool history now also runs from the npm
  package.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `bf5ad0c1`, npm `shinjuku-shielded@0.3.74`

- An unshield (a send to a normal Solana address) answers as soon as the
  transfer is final on chain, with its transaction. The wallet then checks
  the pool history by itself; there is nothing to do. If an MCP ends before
  that check ends, the next MCP finishes it.
- With `--tor`, a new wallet first tries the two facilitator onion addresses
  that the most Tor directory relays carry. The other two stay as spares.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `ff6f25bc`, npm `shinjuku-shielded@0.3.73`

- A wallet that checked the pool history before needs only the newest part
  of it: it reads one small page beside the full list and stops waiting for
  the full list when the small page and its saved records pass every check.
  Every wallet sends the same two requests and reads both to the end.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `07990722`, npm `shinjuku-shielded@0.3.72`

- With `--tor`, a new MCP's first payment asks for the pool history at the
  same time as its pool read, not after it. When the pool moved since the
  wallet's last check, the payment waits less.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `61674c4e`, npm `shinjuku-shielded@0.3.71`

- When money you added has landed but is not counted yet, the balance answer
  now tells you that nothing is needed from you, and tells the agent to check
  again in the same turn. Before, some agents stopped and waited for you.
- The wallet reuses its saved program check for a slightly older pool view when
  the program did not change, so a send-back does not repeat that check.
- With `--tor`, a pool read that gets no answer in 5 seconds goes once more on
  another Tor circuit; the first answer wins.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `ae568c80`, npm `shinjuku-shielded@0.3.70`

- A new MCP's first payment waits less for its history check. The check now
  uses the pool read that the payment already makes, with the same checks, and
  sends no extra reads of its own. If that read lacks a needed field, the
  wallet reads as before.
- A history snapshot's age now counts from its pool read, so a snapshot that
  took long to load is not read again at once for the proof.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `c6cbe0a6`, npm `shinjuku-shielded@0.3.69`

- Setup now checks the pool history and the program while it downloads the
  proof tools, so the first balance after a deposit does not have to do that
  check again. Setup never waits for it, and nothing it starts runs on after
  setup ends. With `--tor` it uses its own Tor circuit, never a direct one.
- When the history service has no record newer than the wallet's last one,
  the wallet asks once more after 2 seconds before it reads the whole history.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `3d64f9b4`, npm `shinjuku-shielded@0.3.68`

- An unshield, a merge or a pocket fill no longer gets refused by its own
  check when the pool adds new records while its quote is still valid. The
  wallet now checks a quote against the same records the facilitator and the
  program accept. In one case a payment was refused 12 times this way until
  its quote ran out.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `4d9b6de2`, npm `shinjuku-shielded@0.3.67`

- Over Tor, a check read of one of your own past transactions that has no
  good answer after 4 seconds is sent once more on another Tor circuit, and
  the first good answer is used. In one test on 0.3.65 two such reads
  stalled for 20 seconds each on one slow circuit.
- When two steps of one wallet process need the same full check of the
  program's history, the second step uses the result of the check that is
  already running and verifies it with its own reads, instead of a second
  full check. It waits for that check for 45 seconds at most.
- When neither main facilitator onion answers, the two spare onions join
  after 8 seconds, not 15 seconds.
- The wallet no longer uses one history onion that did not answer new
  clients. Three history onions remain.
- Each step of an unshield now writes its time to the local log.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `402e7c36`, npm `shinjuku-shielded@0.3.66`

- The wallet downloads the pool's history page once at a time. When a
  payment needs that page while an earlier read of it is still on its way,
  the payment uses that read instead of a second download on the same
  connection. In one test on 0.3.65 a first payment after the pool moved
  took 85 seconds because two downloads of the page slowed each other.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `f1563e53`, npm `shinjuku-shielded@0.3.65`

- When the history server is a moment behind the chain right after a
  payment, the wallet now keeps the history page that is already on its way
  instead of cutting it and asking for it again. In one test on 0.3.64 a
  second request right after the first payment waited 38 seconds for that.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `f7b2fe09`, npm `shinjuku-shielded@0.3.64`

- Before a payment's proof, the wallet checks its saved check of our program
  on the chain from the pool read it already makes, not by one more round
  trip. Over Tor that round trip took 0.3 to 0.8 seconds, and in 13 of 16
  measured first payments the proof waited for it.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `f3c65200`, npm `shinjuku-shielded@0.3.63`

- The setup line and every host entry are now
  `npx -y --no-audit --no-fund shinjuku-shielded ...`. Without the two flags,
  npx sends npm's audit request when it installs a new version, and on
  2026-10-22 that request hung for about 5 minutes. `setup --add-to` replaces
  an entry that an older setup wrote.
- Over Tor, a pool history request that gets no answer moves to the next
  history onion, and a history source that answers nothing for 60 seconds
  ends the load with a plain error, not a wait of several minutes.
- Over Tor, a long-running MCP can again move to a new circuit after a stall
  once the new circuit has answered.
- The add-funds answer says to ask once more about 1 minute after the random
  privacy wait, for hosts that close the MCP after each answer.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `d9319f9c`, npm `shinjuku-shielded@0.3.62`

- Over Tor, a tool that needs the private pocket now waits for the pool's
  pocket list itself, up to 60 seconds. Before, it waited 15 seconds and then
  refused with "Nothing was paid or moved" when a slow Tor circuit made the
  list arrive later.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `fd8f40cf`, npm `shinjuku-shielded@0.3.61`

- A new MCP process now builds the private balance's spent-note tree from its
  saved history while the first payment waits for the network. Before, it
  built the whole tree after that wait. If the saved tree does not match the
  chain, the wallet builds it again in full, as before.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `ad143a47`, npm `shinjuku-shielded@0.3.60`

- Over Tor, the facilitator also answers on two spare onion addresses. When
  neither main onion address answers in 15 seconds, the wallet tries the
  spares too, and one line says so. Before, setup could stop after
  100 seconds when Tor could not look up the two main addresses.
- When `wallet_balance` finishes your deposit and the new balance is not
  counted yet, it says that the USDC landed and is being counted (ask again
  in about 30 seconds). Before, it said that the balance is not known yet
  and to ask again in a minute.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `a18f4dcc`, npm `shinjuku-shielded@0.3.59`

- When `wallet_transfer_token` finishes, the answer says that no tool of
  this wallet moves the SOL on the wallet's own key out yet, and that no
  private route for that SOL exists yet. The SOL pays the fees of your next
  sells.
- When USDC arrives at an add-funds address, `wallet_balance` says that the
  wait before the deposit is a random privacy wait (0 to 5 minutes). The
  wait hides the link between your deposit and your private balance. The
  wait did not change.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `780f6896`, npm `shinjuku-shielded@0.3.58`

- `setup --tor` on a Tor that has just started: setup tries the release
  document again for up to 110 seconds, shows a progress line every
  10 seconds, and says that Tor has no path to the onion service yet when
  nothing answers. Before, it stopped after about 50 seconds with "no answer".
- Over Tor, a request to the facilitator waits for the fastest onion address
  for at most 15 seconds. Then it tries each onion address in turn. It never
  goes to the clearnet address.
- `setup --tor --proxy http://127.0.0.1:<port>` keeps that port in
  `config.json` (`torTunnel`), and `mcp` uses it.
- When the wallet cannot read the receipt of a deposit that landed, it looks
  for the deposit in the pool history over the history connection (its onion
  under Tor). Each look stops after 120 seconds, and the next status call
  tries again. Before, one look could take many minutes (19 minutes in our
  test).
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-22: wallet release `a5a9b7dd`, npm `shinjuku-shielded@0.3.57`

- `wallet_transfer_token` closes the sold token's empty account on the
  wallet's own key before the private send starts, so its rent comes back
  as SOL. The done answer names the SOL that stays on the key to pay the
  fees of your next transfer.
- `wallet_balance` finishes an add-funds deposit that an earlier, closed
  process started but did not sign, and one whose wait has passed.
- `wallet_balance` lists the other tokens on the wallet's own key by mint
  (`ownKeyTokens`), so a token you sent for `wallet_transfer_token` shows
  before the transfer.
- The wallet builds a part of the payment proof from its saved history on a
  second thread at start. We did not measure the first payment yet.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-21: wallet release `e18d1d95`, npm `shinjuku-shielded@0.3.56`

- Less work inside the first payment after a start. The wallet folds its
  saved history while it waits for the live pool read (our test: the fold
  after the start went from 0.74-0.80 s to 0.01-0.39 s). Every check still
  runs against the live pool account.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-21: wallet release `70ff655b`, npm `shinjuku-shielded@0.3.55`

- `wallet_balance` and `x402_preview` show `network`: `tor`, `proxy` or
  `direct`, with one line that says who can see your IP address. Your agent
  can now tell you that your payments go through Tor.
- `setup --tor` records Tor for the MCP, the same as `--prefer-tor`. The
  proof-tools download prints its progress every 10 s, and a setup error
  prints the whole command that works.
- Added funds that landed on chain show as `landingAtomic` until the wallet
  counts them, and `wallet_balance` finishes a sent deposit within 20 s of
  the call. This helps hosts that end the MCP server after each answer.
- The add-funds wait says when to ask again, and that the funds become
  private within about 1 minute of that request.
- `wallet_transfer_token` answers name the address you gave, say that the
  steps continue at your next request if the chat ends, and say that the
  address already has a USDC account. A part whose time passed while the
  wallet did not run waits again from the next start; the answer says so.
- Terminal texts are ASCII only, so a Windows console shows them correctly.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-21: wallet release `285d2c1d`, npm `shinjuku-shielded@0.3.54`

- Money flags take USDC. Write `--max-payment 0.05` for 5 cents and
  `--max-session 2` for 2 USDC. `setup` and the other commands refuse a
  whole number from 1000 up (the old atomic form) and print its USDC form.
  `mcp` still reads an old launch line as atomic, and `wallet_balance` tells
  you how to write it in USDC. Tool arguments stay atomic (`amount_atomic`).
- `--max-session` is the most this wallet pays in any 24 hours, from every
  MCP process together. `--max-shield` and `--max-unshield` count 24 hours
  the same way.
- "Send all my USDC" in one call. When your balance sits in more than one
  part, `wallet_unshield` joins the parts and sends in the same call if your
  host shows progress (our test: 0.02 USDC in 2 parts, 137 s to "Sent",
  about 55 s of it a random privacy wait). Without progress, the answer
  says how many more asks it needs and when.
- A send the wallet keeps for later says when it tries again and why. It
  stops after 8 tries in about 90 minutes, and says so.
- Clear refusals. A send above your balance, from an empty balance, or while
  a deposit is still on its way says the numbers, the amount that works now,
  and when to ask again. `to` may be left out when exactly one
  `--unshield-to` address is set.
- `wallet_receipts`: a send that did not go says why (`not_sent` with
  `reason`); a sent row's `at` is the time it left, and `startedAt` the
  start.
- A wallet that received payments but never shielded can now unshield one
  received payment directly.
- Every money record survives a crash in the middle of a write.
- `x402_pay` no longer says "The page was free" for a page that refused the
  request (for example HTTP 403 from a seller that blocks Tor exits). It
  says the status and that nothing was paid.
- `--tor` runs race four onions of our history service and keep the first
  that answers. A Node.js without the proxy support that `--tor` needs is
  refused at the start, before anything is sent.
  Node.js 22.21 or later, or Node.js 24 or later.
- The tool list shows 12 tools. `wallet_receive_shielded` left the list
  (it comes back with private escrow deals); it still answers by name.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-20: wallet release `667ac38b`, npm `shinjuku-shielded@0.3.53`

- Simpler start. `npx -y shinjuku-shielded setup` prints the host line to
  paste and how to add funds. Ask your agent to add funds:
  `wallet_add_funds` gives a one-time address, and amounts from 0.01 USDC
  become private by themselves.
- Plain answers. Every tool answer starts with a `say` line in plain words,
  and amounts also show as USDC text beside the atomic fields. No field was
  renamed or removed.
- A slow seller no longer holds your agent. After 25 s, `x402_pay` answers
  `seller_working` with its `request_id`. Call `x402_pay` again with that
  `request_id` to get the answer; it never pays twice. `inference_chat` does
  the same.
- A seller that stops answering after the payment: from 45 s the wallet
  reads our payment state, and it stops when the seller is dead (73 s in our
  test, where the old wait took 122 s).
- Faster first payment from a fresh process: the wallet hashes the pool
  roots on worker threads, so it reads your call at once.
- `--tor` runs try both of our onion addresses and keep the first that
  answers.
- New tools: `wallet_receive_shielded` (a one-time private address of this
  wallet), `wallet_transfer_token` and `wallet_transfer_token_status` (sell a
  Solana token for USDC, make it private, and send it privately). The tool
  list shows 13 tools.
- `wallet_receipts` gives `{ok, count, total, facilitatorNote, receipts}`;
  each row has `kind`. The old row fields stay.
- No tool of the Solana Agent Kit plugin changed its name or its arguments.

## 2026-10-11: wallet release `08a4b56f`, npm `shinjuku-shielded@0.3.8`

- Update now. On 2026-10-11 the pool program was upgraded (faster pool
  anchors). 0.3.7 and earlier pin the old program and proof tools
  `ad860e62`, and cannot pay. Run `npx -y shinjuku-shielded@latest setup`
  once: it pins the new program and gets proof tools `47678912`. Your
  wallet, its address, and its balance stay the same.
- A new account pays sooner: the pool takes an anchor about every 30 s when
  it grew, not only every 5 minutes. In our test on 2026-10-11, 12 of 12 new
  accounts could pay within 45 s (median 18 s).
- When an earlier payment is not finished, `x402_pay` names its
  `request_id` (`p03_resource_payment_another_request_unresolved`). Call
  `x402_pay` again with that `request_id` to finish it; it never pays twice.
  `wallet_balance` lists it with its `requestId`.

## 2026-10-11: wallet release `488372b4`, npm `shinjuku-shielded@0.3.7`

- `x402_pay` also pays a stock `exact` seller that settles on our own
  facilitator (`https://shinjukustaition.com/api/x402`), through float pay.
  0.3.6 refused it with `p03_float_seller_uses_our_facilitator`.
- A refund (`p03_float_refund_pending`) comes back within about 7 minutes,
  not 2: it waits for the next pool anchor. `wallet_balance` counts it in
  `refundsInFlightAtomic` for 8 minutes.
- A seller that offers only scheme `confidential` is refused with
  `confidential_retired` by `x402_preview` and `x402_pay`, and nothing is
  paid. `--play-token-file` is accepted and ignored.
- An error answers its code by name: 91 float pay, refund, and seller codes
  answered `unknown_error` before. An error answer carries only the wallet's
  own text.
- The wallet spends the oldest account that pays, so fresh change is not
  tied to your next payment.
- The wallet reads the faster pool anchors (one about every 30 s) that a
  coming upgrade of the pool program adds. Until that upgrade, nothing
  changes.

## 2026-10-11: wallet release `e3348092`, npm `shinjuku-shielded@0.3.6`

- Float pay. `x402_pay` pays a seller that takes only standard `exact`
  (Coinbase CDP, PayAI, any Solana `exact` seller that takes USDC) through
  Shinjuku: the wallet pays us privately from the shielded balance, the
  seller's price plus a flat fee (0.001 USDC), and we pay the seller from our
  own shared float. `x402_preview` shows `feeAtomic` and `totalAtomic`.
  `max_payment_atomic` must cover the total.
- Automatic pockets are off: the wallet fills no pocket. `--ready-pockets`
  is accepted and ignored. With `--proof-tools`, `--exit-proof-tools`, and
  `--profile`, the server returns old pockets to the shielded balance by
  itself while it is idle; `--no-auto-pockets` stops that.
- If a seller does not take our payment, `x402_pay` answers
  `p03_float_refund_pending`: the refund comes back to the balance by itself
  within about 2 minutes.
- `wallet_balance` answers one balance (`balanceAtomic`) with a
  `breakdown`: `shieldedAtomic`, `refundsInFlightAtomic`, and
  `setAsideAtomic`.
- A balance split over several accounts: `x402_pay` names the new CLI
  command `shinjuku-wallet merge`, which joins them.
- A refusal by a wallet-file cap names the new CLI command
  `shinjuku-wallet limits`, which changes or removes the cap.
- Hidden amounts (scheme `confidential`, the V0b vault) are retired: the V0b
  program was closed on chain on 2026-10-11.

## 2026-10-10: wallet release `f2ea6840`, npm `shinjuku-shielded@0.3.5`

- The pool program was upgraded, and the shielded pool moved to
  `45mhosfA2MuygZWeqYRVcEZX2Q3gA8KR8FwP6AZkK1zR`. The old pool
  `AAG16mNWTtC1sBeu2tTVTwWjqWXCefLTCByVPj5X3kV8` is retired; earlier releases
  refuse payments. Run `npx -y shinjuku-shielded@latest setup` once: it keeps
  the old wallet file, makes a wallet for the new pool (a new address), and
  downloads proof tools `ad860e62`.
- No spending limit by default. `--max-payment`, `--max-session`, and
  `--max-total` are optional; a setup rerun lifts the old default caps.
- The first deposit into an empty pool works.
- A pocket fill for a split shielded balance says why it fails: each part is
  smaller than one pocket. Shield 1 more USDC so one part holds a full pocket.

## 2026-10-09: wallet release `14dd9efa`, npm `shinjuku-shielded@0.3.4`

- Proof tools `9975fdf8` pin the upgraded pool program. With 0.3.3, setup
  worked but every pocket fill failed (`p03_seller_chain_pin_mismatch`). Run
  `npx -y shinjuku-shielded@latest setup` once.

## 2026-10-09: wallet release `36d0219d`, npm `shinjuku-shielded@0.3.3`

- Required after the pool program upgrade of 2026-10-09: earlier releases
  refuse payments. Run `npx -y shinjuku-shielded@latest setup` once; it keeps
  your wallet and downloads proof tools `a9f18f88`.

## 2026-10-08: wallet release `d2a7291f`, npm `shinjuku-shielded@0.3.2`

- When the facilitator is short of network-fee funds, the agent hears
  `p03_facilitator_underfunded`: nothing was spent; try again later with a new
  request_id.
- A seller that closes a payment request now tells the agent to pay again with
  a NEW request_id.

## 2026-10-08: wallet release `a8516e49`, npm `shinjuku-shielded@0.3.1`

- A shield call made right after the MCP server starts now waits for the
  server's own background pocket check instead of failing `wallet_locked`.
- Tool texts name fewer third-party wallets.
- Otherwise the same as 0.3.0 (wallet release `94a357bc`, no longer served).

## 2026-10-08: wallet release `94a357bc`, npm `shinjuku-shielded@0.3.0`

Update from 0.2.0. The pool program was upgraded on 2026-10-08. The proof
tools that 0.2.0 pins (`24e819a8`) name the program from before the upgrade,
so setup from 0.2.0 now refuses production. 0.3.0 pins the new set
`262e1e98`.

- `x402_discover`: searches public x402 listings (Coinbase x402 Bazaar,
  PayAI, Dexter, and others) on your machine. The first call takes about
  15 s.
- Automatic pockets: for a standard `exact` seller, `x402_pay` fills a
  1 USDC pocket from the shielded balance when it needs one.
  `--ready-pockets 0-5` (default 1) sets how many stay ready.
  `--no-auto-pockets` turns this off.
- Image answers: `x402_pay` returns image bytes (also JSON `image_base64`)
  as an MCP image block and saves the file.
- `wallet_shield` needs no SOL. Our facilitator's relayer pays the network
  fee; you pay the shield cost.
- An Approve button with an empty form (Hermes) counts as accept.
- `x402_preview` and `x402_pay` price a seller that lists several networks
  from its Solana offer.
- The pool history comes through our facilitator's https history proxy by
  default. A new wallet is ready in about 60 s instead of about 220 s.
- A seller receipt that names another payer is checked on chain.
- A payment that landed, from a seller that gives no answer, closes as paid.
- Verified on production with a new wallet, the default setup, and no SOL at
  any time: a shield
  ([`5np1EYjN…fH2`](https://solscan.io/tx/5np1EYjNkr5w7Tt6ng2KQ9cp7RgNkhpwAKtzkm2nyRKMgi1FsmM3TMZMx8EkyiAV4sUtoQ3mTtTbuehas1qV3fH2)),
  then `x402_pay` to a public satellite-imagery seller: 0.013 USDC, HTTP 200
  in 8 s, a JPEG answer
  ([`iC6gnjFM…DHwC`](https://solscan.io/tx/iC6gnjFMBwHaqArgcRL6C5GdNbcWMom82cZqcQ2C2xup9aXJX91HXmWozQcVvAyTSTZsRptynfdbBPjjxG9DHwC)).

## 2026-10-08: wallet release `11fe6b40`, npm `shinjuku-shielded@0.2.0`

One command installs and runs it: `npx -y shinjuku-shielded mcp`.

- First run with no wallet: in a terminal it asks "Set up Shinjuku Shielded
  now? (y/n)". Started by an agent app, it serves a setup mode: the tools
  `shinjuku_setup` and `wallet_status`, and the app asks you "Create a
  Shinjuku Shielded wallet on this machine?" (MCP elicitation). Nothing is
  created until you accept. The money tools answer `wallet_not_set_up`.
- `setup` (also run by the first start): creates the wallet with a
  generated passphrase in a private file, shows the recovery file to back
  up, downloads the proof tools and checks every file against a set pinned
  inside the wallet (the server alone cannot change it), and writes
  `config.json`. `--add-to claude-code|claude-desktop|cursor` adds the server
  to your agent app. `--yes` asks nothing.
- `mcp` with no flags reads `config.json`. Flags on the command line still
  win.
- Linux, or Windows with WSL. macOS is not supported (the provers are Linux
  programs).
- In the official MCP Registry as `io.github.ShinjukuStaition/shinjuku-mcp`
  0.2.0. npm versions are published from this repository's workflow with
  npm provenance (from 0.1.1).
- Verified on production: an end-to-end run from the published package
  (setup in 25 s, `mcp` with no flags, a balance read).

## 2026-10-08: npm `shinjuku-shielded@0.1.1` (same wallet release `1a336885`)

- `server.json` for the official MCP Registry
  (`io.github.ShinjukuStaition/shinjuku-mcp`).
- `mcpName` in `npm/package.json`. The registry checks it on npm, so it
  needs a new npm version before the registry entry.
- `examples/`: Claude Code, Claude Desktop, Cursor, and Hermes Agent configs,
  a first-10-minutes walkthrough, and 10 plain requests.
- `SECURITY.md`.

## 2026-10-08: wallet release `1a336885`, npm `shinjuku-shielded@0.1.0`

The MCP runs by itself. You talk in plain words, and the server does the
upkeep.

- `wallet_shield` is on by default with `--proof-tools`. `--no-shield`
  turns it off. `--max-shield` is optional. `--allow-shield` is still
  accepted for older configs.
- `wallet_unshield` is on with `--exit-proof-tools` and `--profile`. An
  address in `--unshield-to` is sent at once. Any other address is sent only
  after you confirm it in your MCP client (MCP elicitation): "Send X USDC
  from your shielded balance to <address>?". A decline, or no answer in 5
  minutes, sends nothing (`mcp_unshield_declined`). A client that cannot ask
  is refused (`mcp_unshield_to_not_allowed`). `--max-unshield` is optional.
- The wallet's own key is refused as a send address. It made the deposits,
  so a send there would link them. The server does not start when
  `--unshield-to` names it.
- Automatic refresh: after a deposit lands, and before a payment or a send
  when the local balance is stale, the server reads the chain itself.
  `wallet_balance` answers with `refreshing: true` after about 20 s and
  finishes in the background.
- Automatic backup: after each shield and each send, the wallet writes an
  encrypted backup to `$SHIELDED_WALLET_HOME/auto-backups/<pool>/` and keeps
  the newest 5.
- A send is your own money. It does not count against the payment budget of
  the wallet file (`init --max-payment`, `--max-cumulative`). Payments to
  sellers still count.
- The server instructions and the tool descriptions map plain requests
  ("what is my balance", "shield 5 USDC", "pay this URL", "send 2 USDC to
  <address>") to one tool each.
- npm: `shinjuku-shielded@0.1.0` holds this release unchanged
  (`shinjukuRelease` `1a336885`). Commands: `shinjuku-shielded` and
  `shinjuku-wallet`.

## 2026-10-08: wallet release `b7d6f394`

- New tool `wallet_shield {amount_atomic, request_id}`: moves the public
  USDC on the wallet's own key into the shielded balance. Off unless you
  start the server with `--allow-shield --max-shield <atomic>`.
- New tool `wallet_unshield {amount_atomic, to, request_id}`: sends shielded
  USDC to a public Solana address. Off unless you start the server with
  `--unshield-to <address> --max-unshield <atomic>`.
- Both take minutes. The same `request_id` reads the status and never moves
  money twice, also after a restart.
- `wallet_balance` shows SHIELDED and UNSHIELDED separately: the private
  balance, and the plain USDC on the wallet's own key.

## 2026-10-07: the `mcp` command

- `shinjuku-wallet mcp`: a local MCP server on stdio. Your keys and
  passphrase stay in that process.
- Tools: `x402_preview` (the price and the cap check; pays nothing),
  `x402_pay` (alias `fetch_paid`; pays and returns the answer),
  `wallet_balance`, `wallet_receipts`, `wallet_cancel`.
- Caps: `--max-payment` and `--max-session` are required. Without them the
  server does not start (`mcp_cap_required`). A tool argument can only lower
  the per-payment cap. Optional: `--max-per-host-day` and `--allow-host`.
- The same `request_id` never pays twice.
- Pays `shielded-exact` from the shielded balance and standard `exact` from
  a ready pocket. Not `confidential`.
- `--tor` sends seller requests, memo reads, and RPC calls through Tor.
