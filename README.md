# a4sx plugin for Claude Code

[a4sx](https://session-exchange.com) is a library and marketplace for coding-agent sessions. This
plugin brings it into Claude Code:

- **Save** the current Claude Code session to your private a4sx library.
- **Search** sessions other people have published, or your own library.
- **Continue** a session: add it to your library and pick it up in Claude Code, in this folder or in
  a new terminal session.
- **Meshes and cells:** see your a4sx meshes and the cells on this computer, create a mesh or an
  invite, set a mesh's policy, and run a session as a cell. Changes run only after you say yes.

This repository is both a plugin marketplace named `a4sx` and the plugin `a4sx` itself.

## Install

```
/plugin marketplace add crossvault/a4sx-claude-plugins
/plugin install a4sx@a4sx
```

Saving, continuing and the mesh commands also need the official a4sx CLI (Python 3.10 or newer).
Install it in a terminal, then sign in. `/a4sx:setup` walks you through it.

```sh
# Linux, macOS, WSL
curl -fsSL https://session-exchange.com/install.sh | sh
```

```powershell
# Windows (PowerShell)
irm https://session-exchange.com/install.ps1 | iex
```

```sh
a4sx login
```

On Windows, the Microsoft Store build of Python doesn't work with a4sx (Claude Code can't see the
files it writes); the installer skips it and asks for another Python if it is the only one.

`a4sx login` opens a browser device sign-in and stores the session in a file only your user can read
(`~/.config/a4sx/session` on Linux and macOS). The plugin never asks for a token and never writes one
to a file.

## Examples

- "Save this session to my a4sx library": Claude runs `/a4sx:publish` when you type it, shows the
  scrub preview and asks before anything is uploaded.
- "Has anyone published a session that migrates a Django app to async views?": Claude searches the
  marketplace with `/a4sx:search`, after Claude Code asks you to allow the query.
- "Which a4sx meshes am I in, and which of my cells are running?": Claude uses `/a4sx:mesh` and asks
  before each `a4sx mesh` command.
- `/a4sx:resume <listing-id>`: adds a free listing to your library and continues it here or in a
  terminal.
- `/a4sx:cell`: puts together the command that runs this session as a cell in one of your meshes.

## Commands

| Command | What it does | a4sx interface it uses | Changes on your computer |
|---|---|---|---|
| `/a4sx:search <query>` | Searches published marketplace sessions, or your own library once you are signed in. Your query is sent to session-exchange.com; Claude Code asks first unless the tool is already allowed or permission prompts are bypassed. | MCP tools `search_sessions` and `get_session_summary` (marketplace: no sign-in; your library: MCP sign-in) | none |
| `/a4sx:publish [title]` | Saves this session to your **private** library. Shows a scrub preview and asks before uploading. | CLI `a4sx push --dry-run`, then `a4sx push` | none |
| `/a4sx:resume <id>` | Adds a listing to your library and continues it: in Claude Code's history for this folder, or in a terminal with a launch profile you pick. | MCP `get_session_summary`, CLI `a4sx acquire`, `a4sx launch --a4sx-session … --seed-only`, `a4sx profiles --json`; you run `a4sx launch --a4sx-session <id>` | with your yes: a new session in Claude Code's local history for this folder |
| `/a4sx:setup` | Checks the a4sx CLI, shows how to install it (Linux, macOS, WSL, Windows) and sign in, and updates it. | CLI `a4sx version`, `a4sx update` | with your yes: `a4sx update` replaces the installed CLI |
| `/a4sx:mesh [mesh]` | Shows your meshes, a mesh's card, policy and agent sessions (peers), and the cells stored on this computer. Read-only. | CLI `a4sx mesh list`, `mesh show`, `mesh policy` (show only), `mesh peers`, `mesh cells` | none |
| `/a4sx:mesh-manage …` | Creates a mesh or an invite, sets a mesh's traffic policy, renames or stops a cell, one change at a time. Gives you the commands to join a mesh and to allow a peer, for your own terminal. | CLI `a4sx mesh create`, `mesh invite`, `mesh policy <mesh> <policy>`, `mesh cell rename`, `mesh cell stop` | with your yes: renames a stored cell, or stops a cell running here |
| `/a4sx:cell` | Puts together the `a4sx launch --cell …` command that runs this session, or a library session, as a cell. You run it in your own terminal. | CLI `a4sx mesh cells --json` | none (you run the launch) |
| `/a4sx:help` | Explains a4sx and the commands. Claude also uses it on its own when you mention a4sx. | none | none |

The plugin also registers the hosted a4sx MCP server, `https://session-exchange.com/mcp`, as `a4sx`
(see `/mcp`). If you already added the same server yourself with `claude mcp add`, Claude Code
connects once and uses your entry, not the plugin's. The skills' pre-approved tool names then don't
match, so Claude asks for permission on every call. To let the plugin's skills use their
pre-approved tools, remove your own entry with `claude mcp remove <name>`, using the name you gave
it (`claude mcp list` shows it).

### What the plugin pre-approves

Only these, each inside the one command that uses it. Everything else, every upload and every
change included, needs your permission when Claude Code asks:

- `printenv A4SX_HARNESS A4SX_MESH_SESSION`, which tells whether Claude Code runs inside an a4sx
  session (see below), in `/a4sx:publish`, `/a4sx:resume`, `/a4sx:setup`, `/a4sx:mesh-manage` and
  `/a4sx:cell`;
- `a4sx version` in `/a4sx:publish`, `/a4sx:resume` and `/a4sx:setup`;
- `a4sx push --dry-run …` in `/a4sx:publish` (it uploads nothing);
- the MCP tool `get_session_summary` (a read of a listing) in `/a4sx:search` and `/a4sx:resume`.

`/a4sx:publish`, `/a4sx:resume`, `/a4sx:setup`, `/a4sx:mesh-manage` and `/a4sx:cell` only run when
you type them. Claude does not start an upload or a change on its own. The plugin has no hooks and
runs nothing in the background.

**Inside an a4sx session.** If Claude Code itself runs inside an a4sx session (a mesh cell, or
`a4sx launch --ipc-proxy`), the a4sx CLI there acts as that session, not as you. The commands that
use the CLI then stop and tell you to run them in your own terminal.

**Meshes, safely.** Joining a mesh and allowing a peer to message your agent are never run by
Claude: the plugin gives you the command for your own terminal. Invite links and cell codes never
go through the chat. The plugin never turns on `--auto-allow-ipc-messages`, which delivers mesh
peers' messages to Claude without asking you; if you ask about it, it explains the risk.

**Buying.** No command in this plugin buys anything. The a4sx MCP server also offers
`request_purchase`: it charges nothing itself and returns a link and a code; you check them, confirm
and pay in your browser, on session-exchange.com. The plugin never pre-approves it, so Claude Code
asks you before Claude can call it.

## Services contacted outside the MCP connector

The declared connector is the MCP server `https://session-exchange.com/mcp`. Outside it, the skills
reach only the same first-party service, session-exchange.com, through the official a4sx CLI, by the
routes below. Two commands the skills tell you to run yourself go further, as the last two rows
say: `a4sx login` can hand off to the sign-in provider you choose, and `a4sx launch` sends the
continued session to the model provider in your launch profile.

| Skill | Route | What is sent | When |
|---|---|---|---|
| `/a4sx:publish` | `a4sx push` to the session-exchange.com API | this session's transcript, scrubbed on your machine first, plus the title you choose | only after a `a4sx push --dry-run` preview (which sends nothing), and only after Claude Code asks you: the upload is not pre-approved |
| `/a4sx:resume` | `a4sx acquire` to the session-exchange.com API | the listing id (and tenant) you chose, and your CLI sign-in | only after Claude Code asks you |
| `/a4sx:resume` | `a4sx launch --a4sx-session … --seed-only`: downloads the session from session-exchange.com | the library id and your CLI sign-in | only after your yes and Claude Code's question |
| `/a4sx:resume` | `a4sx profiles --json` to the session-exchange.com API | your CLI sign-in | only if you want to pick a launch profile, after Claude Code asks you |
| `/a4sx:search` | `a4sx list` to the session-exchange.com API | your CLI sign-in | only if you ask for your own library, and only after Claude Code asks you |
| `/a4sx:setup` | `a4sx update`: downloads the newest CLI from session-exchange.com | nothing: a download, without your sign-in | only after your yes and Claude Code's question |
| `/a4sx:mesh` | `a4sx mesh list`, `mesh show`, `mesh policy` (show only) and `mesh peers` to the session-exchange.com API | your CLI sign-in and the mesh you asked about | each only after Claude Code asks you |
| `/a4sx:mesh`, `/a4sx:cell` | `a4sx mesh cells --json`: reads the cells stored on this computer and asks session-exchange.com about them | your CLI sign-in | each only after Claude Code asks you |
| `/a4sx:mesh-manage` | `a4sx mesh create`, `mesh invite` and `mesh policy <mesh> <policy>` to the session-exchange.com API; some open a confirmation page in your browser | your CLI sign-in and what you chose (mesh name, protocol label, policy, invite options) | only after your yes and Claude Code's question |
| `/a4sx:mesh-manage` | `a4sx mesh cell rename` to the session-exchange.com API; `a4sx mesh cell stop` stays on this computer | your CLI sign-in, the cell and its new name | only after your yes and Claude Code's question |
| `/a4sx:publish`, `/a4sx:resume`, `/a4sx:setup` | the CLI installers `https://session-exchange.com/install.sh` and `install.ps1` | nothing: a download | only if you run them, or ask Claude to; the skills don't run them on their own |
| all skills that use the CLI | `a4sx login`: a browser sign-in at session-exchange.com | your sign-in, through the provider you pick there (for example Google, GitHub or Microsoft) | only when you run it |
| `/a4sx:resume`, `/a4sx:cell` | `a4sx launch`: downloads the session from session-exchange.com if needed, then starts Claude Code with your launch profile; a cell also registers with its mesh at session-exchange.com and exchanges messages with the mesh's other cells, which may run on other people's computers | the continued session goes to the model provider in that profile (Anthropic by default) | only when you run it in a terminal |

## Sign in

There are two ways to sign in. They are independent; use either or both.

- **MCP sign-in, from Claude Code.** Run `/mcp`, select the plugin's `a4sx` server and choose to
  authenticate. Claude Code opens the a4sx sign-in in your browser (GitHub or Google), then a
  consent page that names the client, the access it asks for and how long it lasts. After you approve,
  Claude Code holds the access itself; you never copy a token. You can see and revoke the connection
  under Account › Agent keys on session-exchange.com.
- **CLI sign-in, in a terminal.** `a4sx login`, as above. `/a4sx:publish`, `/a4sx:resume`,
  `/a4sx:mesh`, `/a4sx:mesh-manage` and `/a4sx:cell` use the CLI, so they need this sign-in. Mesh
  information is available through the CLI only, not through the MCP sign-in.

## What needs which sign-in

| | No sign-in | MCP sign-in (`/mcp`) | CLI sign-in (`a4sx login`) |
|---|---|---|---|
| Search the marketplace, read summaries | MCP `search_sessions`, `get_session_summary`; CLI `a4sx search` | same | same |
| Search your own library | | MCP `search_sessions` with `scope=library` | `a4sx list` |
| Save this session | | MCP `publish_session` (up to 2 MiB) | `a4sx push`, used by `/a4sx:publish` |
| Add a listing to your library | | MCP `acquire_session` | `a4sx acquire`, used by `/a4sx:resume` |
| Load a library session as context into this conversation | | MCP `fetch_session_context` | |
| Continue a session | | | `a4sx launch --a4sx-session`, with `--seed-only` for Claude Code's history |
| Meshes and cells | | | `a4sx mesh …`, used by `/a4sx:mesh`, `/a4sx:mesh-manage` and `/a4sx:cell` |

A tool that needs more access than you approved answers that it needs it; Claude Code may then
ask you to approve again in the browser. If it doesn't, sign in again from `/mcp`, or use the
CLI for that step.

Only **Claude Code** sessions can be continued today. Sessions recorded with other agents
(Codex CLI, Gemini CLI, OpenCode) show up in search, but you can only view them on the web.

## What gets uploaded

`/a4sx:publish` uploads this session's transcript: the JSONL file Claude Code keeps under
`~/.claude/projects/`. It contains your prompts, Claude's replies, every tool call and its output,
including file contents Claude read and command output it saw.

- **Private by default.** A save lands in your private library. Nothing is listed publicly. Listing a
  session on the marketplace is a separate, reviewed step you take in the a4sx web app.
- **Scrubbed twice.** The CLI scrubs the transcript on your machine before upload, and the server
  scrubs it again before storing it. The plugin runs `a4sx push --dry-run` first and shows you which
  lines the scrub changes (values masked), then asks before it uploads.
- **Each save is a new version.** Saving again adds a version; it never overwrites an earlier one.
  You can delete an entry with `a4sx delete <name>`.

### Limits of the automatic privacy processing

The scrub is **pattern-based**. It removes known secret shapes (for example API keys and tokens),
command-line passwords, and personal data, host names, IP addresses and paths that match its
patterns. a4sx's privacy policy calls the server-side redaction "a backstop, not a guarantee".

It cannot know what is sensitive to you. A customer name, proprietary source code, an internal URL in
an unusual form, or an unreleased product name looks like ordinary text to it. Read the dry-run
output, and don't save sessions that contain material you may not share with a4sx.

How a4sx stores and processes uploaded data is described in the
[privacy policy](https://session-exchange.com/privacy). Where this README and the policy differ, the
policy applies.

## Gaps

These are things the plugin does not do, because no a4sx interface for them exists yet, or because
they belong in your own terminal or browser:

- **Continuing needs a new session.** A session can't be continued inside the current
  conversation. `/a4sx:resume` prepares it in Claude Code's history (`/resume` opens it) or gives you
  the `a4sx launch` command. With MCP sign-in, `fetch_session_context` can load one as context here,
  which is not the same as resuming it.
- **Cells start in a terminal.** `a4sx launch --cell` starts its own Claude Code session, so
  `/a4sx:cell` gives you the command instead of running it.
- **Joining a mesh and allowing peers** are left to your own terminal, on purpose.
- **Launch profiles** are listed, not changed. Change them with `a4sx profile` in a terminal or on
  the website.
- **Folders** in your library are not managed by this plugin; the a4sx VS Code extension manages them.
- **Publishing publicly** is a web-app step. Neither the CLI nor MCP lists a session publicly.
- **Buying** is a web-app step. No tool pays.
- **Large sessions over MCP.** `publish_session` takes up to 2 MiB; larger transcripts need the CLI.

## Development

```sh
./scripts/validate.sh
```

This runs a basic JSON and required-field check and, when the `claude` CLI is installed,
`claude plugin validate --strict` on the marketplace and on the plugin. CI runs the same script.

To try the plugin from a checkout:

```
/plugin marketplace add ./path/to/a4sx-claude-plugins
/plugin install a4sx@a4sx
```

## Contributing, security, license

- [CONTRIBUTING.md](CONTRIBUTING.md): pull requests need a DCO sign-off.
- [SECURITY.md](SECURITY.md): how to report a vulnerability.
- [MIT License](LICENSE). Copyright (c) 2026 crossVault GmbH.
