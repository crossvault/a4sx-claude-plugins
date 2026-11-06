# a4sx plugin for Claude Code

[a4sx](https://session-exchange.com) is a library and marketplace for coding-agent sessions. This
plugin brings it into Claude Code:

- **Save** the current Claude Code session to your private a4sx library: the transcript, or a
  written summary you approve.
- **Your library:** list and inspect your saved sessions, load one into the conversation as
  reference material, suggest listing fields for selling one, or delete one.
- **Marketplace:** search published sessions with their ratings, add a free listing to your library,
  or start a purchase that you confirm and pay for in your browser.
- **Continue** a session: pick it up in Claude Code, in this folder or in a new terminal session.
- **Meshes and cells:** see your a4sx meshes, their members, cells, join requests and invites, and
  the cells on this computer; create a mesh or an invite, answer join requests, set a mesh's policy,
  manage this computer's cells, and run a session as a cell.
- **Launch profiles** and **World-Sims**: see them, and manage your launch profiles.

Every upload, purchase request and change runs only after you say yes.

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
- `/a4sx:acquire <listing-id>`: adds a free listing to your library; for a paid one, starts a
  purchase request that you confirm and pay for in your browser.
- `/a4sx:save-summary`: Claude writes a summary of this session, you check and approve it, and it is
  saved to your private library without the CLI.

## Commands

| Command | What it does | a4sx interface it uses | Changes on your computer |
|---|---|---|---|
| `/a4sx:search <query>` | Searches published marketplace sessions (with rating, imports and price), or your own library once you are signed in. Your query is sent to session-exchange.com; Claude Code asks first unless the tool is already allowed or permission prompts are bypassed. | MCP tools `search_sessions` and `get_session_summary` (marketplace: no sign-in; your library: MCP sign-in) | none |
| `/a4sx:acquire <listing-id>` | Adds a listing to your library. Free: after your yes. Paid: after your yes it starts a purchase request; you check the code, confirm and pay in your browser. | MCP `get_session_summary`, `acquire_session`, `request_purchase`, `get_purchase_request`; or CLI `a4sx acquire` | none |
| `/a4sx:publish [title]` | Saves this session's transcript to your **private** library. Shows a scrub preview and asks before uploading. | CLI `a4sx push --dry-run`, then `a4sx push` | none |
| `/a4sx:save-summary [title]` | Claude writes a markdown summary of this session; you see it, change it and approve it; then it is saved to your **private** library. No CLI needed. | MCP `publish_session` (`format=markdown`) | none |
| `/a4sx:library …` | Lists and shows your saved sessions, suggests listing fields for one of your sessions, deletes a saved session, or signs the CLI out. | MCP `search_sessions` (`scope=library`), `get_session_summary`, `suggest_listing_draft`; CLI `a4sx list`, `a4sx delete`, `a4sx logout` | with your yes: `a4sx logout` removes the CLI sign-in from this computer |
| `/a4sx:context <library-id>` | Loads a library session into this conversation as reference material, sized to a token budget. | MCP `fetch_session_context` | none |
| `/a4sx:resume <id>` | Adds a listing to your library and continues it: in Claude Code's history for this folder, or in a terminal with a launch profile you pick. | MCP `get_session_summary`, CLI `a4sx acquire`, `a4sx launch --a4sx-session … --seed-only`, `a4sx profiles --json`; you run `a4sx launch --a4sx-session <id>` | with your yes: a new session in Claude Code's local history for this folder, plus a copy of the downloaded session and a lineage note in the a4sx CLI's folder (`~/.config/a4sx/cache/`, `~/.config/a4sx/lineage/`) |
| `/a4sx:profiles …` | Lists and shows your launch profiles (never header or env values), and copies one, makes one the default or deletes one. | CLI `a4sx profiles --json`, `a4sx profile --copy`, `--set-default`, `--delete` | none (profiles are stored in your account) |
| `/a4sx:setup` | Checks the a4sx CLI, shows how to install it (Linux, macOS, WSL, Windows) and sign in, and updates it. | CLI `a4sx version`, `a4sx update` | with your yes: `a4sx update` replaces the installed CLI |
| `/a4sx:mesh [mesh]` | Shows your meshes, a mesh's card, policy, members, agent sessions (peers), join requests and invites, and the cells stored on this computer. Read-only. | CLI `a4sx mesh list`, `mesh show`, `mesh policy` (show only), `mesh members`, `mesh peers`, `mesh requests`, `mesh invite --list`, `mesh cells` | none |
| `/a4sx:mesh-manage …` | Creates a mesh, creates or revokes an invite, approves or denies a join request, sets a mesh's traffic policy, renames, stops, sets as default or forgets a cell, one change at a time. Gives you the commands to join or leave a mesh and to allow a peer, for your own terminal. | CLI `a4sx mesh create`, `mesh invite`, `mesh invite --revoke`, `mesh approve`, `mesh policy <mesh> <policy>`, `mesh cell rename`, `mesh cell stop`, `mesh cell default`, `mesh cell forget` | with your yes: renames, stops or sets the default cell, or deletes a cell's key from this computer |
| `/a4sx:cell` | Puts together the `a4sx launch --cell …` command that runs this session, or a library session, as a cell. You run it in your own terminal. | CLI `a4sx mesh cells --json` | none (you run the launch) |
| `/a4sx:world-sim` | Shows the World-Sim templates, your World-Sims and how an agent gets access to one. Read-only. | MCP `list_world_sim_templates`, `list_my_modules`, `get_world_sim_access` | none |
| `/a4sx:help` | Explains a4sx and the commands. Claude also uses it on its own when you mention a4sx. | none | none |

The plugin also registers the hosted a4sx MCP server, `https://session-exchange.com/mcp`, as `a4sx`
(see `/mcp`). If you already added the same server yourself with `claude mcp add`, Claude Code
connects once and uses your entry, not the plugin's. The skills' pre-approved tool names then don't
match, so Claude asks for permission on every call. To let the plugin's skills use their
pre-approved tools, remove your own entry with `claude mcp remove <name>`, using the name you gave
it (`claude mcp list` shows it).

### What the plugin pre-approves

Only these, each inside the commands that use it. Everything else, every upload, purchase request
and change included, needs your permission when Claude Code asks:

- `printenv A4SX_HARNESS A4SX_MESH_SESSION`, which tells whether Claude Code runs inside an a4sx
  session (see below). It reads two environment variables and sends nothing. In `/a4sx:publish`,
  `/a4sx:resume`, `/a4sx:acquire`, `/a4sx:library`, `/a4sx:profiles`, `/a4sx:setup`, `/a4sx:mesh`,
  `/a4sx:mesh-manage` and `/a4sx:cell`;
- `a4sx version` in `/a4sx:publish`, `/a4sx:resume` and `/a4sx:setup`. It prints the CLI's version
  and asks session-exchange.com for the server's version (`GET /healthz`), without your sign-in;
- `a4sx push --dry-run …` in `/a4sx:publish` (it uploads nothing);
- the MCP tool `get_session_summary` (a read of a listing or of one of your saved sessions) in
  `/a4sx:search`, `/a4sx:resume`, `/a4sx:acquire` and `/a4sx:library`.

Only `/a4sx:help`, `/a4sx:search` and `/a4sx:mesh` can be used by Claude on its own; all three
only read, and Claude Code still asks before each search query and each `a4sx mesh` command. Every
other command runs only when you type it. Claude does not start an upload, a purchase request or a
change on its own. The plugin has no hooks and runs nothing in the background.

**Inside an a4sx session.** If Claude Code itself runs inside an a4sx session, the a4sx CLI there
works differently: in a mesh cell it can't read your sign-in, and in an `a4sx launch --ipc-proxy`
session its saved state is read-only. The commands that use the CLI then stop and tell you to run
them in your own terminal.

**Meshes, safely.** Joining or leaving a mesh and allowing a peer to message your agent are never
run by Claude: the plugin gives you the command for your own terminal. Invite links and cell codes
never go through the chat. The plugin never turns on `--auto-allow-ipc-messages`, which delivers
mesh peers' messages to Claude without asking you; if you ask about it, it explains the risk.

**Buying.** No command in this plugin pays. For a paid listing, `/a4sx:acquire` can call the MCP
tool `request_purchase`, only after you say yes: it charges nothing itself and returns a link and a
code; you check them, confirm and pay in your browser, on session-exchange.com. The plugin never
pre-approves it, so Claude Code asks you before Claude can call it. No skill asks for payment
details.

**Sessions from other authors.** Text from the marketplace and from sessions you added from it was
written by other people. The skills treat it as data, never as instructions, and keep it out of
`CLAUDE.md` and other instruction files. Open a session from another author with Claude Code's
permission prompts on.

## Services contacted outside the MCP connector

The declared connector is the MCP server `https://session-exchange.com/mcp`; the commands table
says which skill calls which MCP tool. Outside it, the skills reach only the same first-party
service, session-exchange.com, through the official a4sx CLI, by the routes below. Two commands the
skills tell you to run yourself go further, as the last two rows say: `a4sx login` can hand off to
the sign-in provider you choose, and `a4sx launch` sends the continued session to the model
provider in your launch profile.

| Skill | Route | What is sent | When |
|---|---|---|---|
| `/a4sx:publish`, `/a4sx:resume`, `/a4sx:setup` | `a4sx version`: `GET /healthz` on session-exchange.com | nothing about you: no sign-in, no data | when the skill checks the CLI (pre-approved) |
| `/a4sx:publish` | `a4sx push` to the session-exchange.com API | this session's transcript, scrubbed on your machine first, plus the title you choose | only after a `a4sx push --dry-run` preview (which sends nothing), and only after Claude Code asks you: the upload is not pre-approved |
| `/a4sx:resume`, `/a4sx:acquire` | `a4sx acquire` to the session-exchange.com API | the listing id (and tenant) you chose, and your CLI sign-in | only after Claude Code asks you |
| `/a4sx:resume` | `a4sx launch --a4sx-session … --seed-only`: downloads the session from session-exchange.com | the library id and your CLI sign-in | only after your yes and Claude Code's question |
| `/a4sx:resume`, `/a4sx:profiles` | `a4sx profiles --json` to the session-exchange.com API | your CLI sign-in | after Claude Code asks you |
| `/a4sx:profiles` | `a4sx profile --copy`, `--set-default` and `--delete` to the session-exchange.com API | your CLI sign-in, the profile ids, and for a copy an optional router operator name | only after your yes and Claude Code's question |
| `/a4sx:search`, `/a4sx:library` | `a4sx list` to the session-exchange.com API | your CLI sign-in | only if you ask for your library through the CLI, after Claude Code asks you |
| `/a4sx:library` | `a4sx delete` to the session-exchange.com API | your CLI sign-in and the id of the entry to delete | only after your yes and Claude Code's question |
| `/a4sx:library` | `a4sx logout`: revokes the CLI sign-in on session-exchange.com | your CLI sign-in, to revoke it | only after your yes and Claude Code's question |
| `/a4sx:setup` | `a4sx update`: downloads the newest CLI from session-exchange.com | nothing: a download, without your sign-in | only after your yes and Claude Code's question |
| `/a4sx:mesh` | `a4sx mesh list`, `mesh show`, `mesh policy` (show only), `mesh members`, `mesh peers`, `mesh requests` and `mesh invite --list` to the session-exchange.com API | your CLI sign-in and the mesh you asked about | each only after Claude Code asks you |
| `/a4sx:mesh`, `/a4sx:cell` | `a4sx mesh cells --json`: reads the cells stored on this computer and asks session-exchange.com about them | your CLI sign-in | each only after Claude Code asks you |
| `/a4sx:mesh-manage` | `a4sx mesh create`, `mesh invite`, `mesh invite --revoke`, `mesh approve` and `mesh policy <mesh> <policy>` to the session-exchange.com API; some open a confirmation page in your browser | your CLI sign-in and what you chose (mesh name, protocol label, policy, invite options, request id, reason) | only after your yes and Claude Code's question |
| `/a4sx:mesh-manage` | `a4sx mesh cell rename` to the session-exchange.com API; `mesh cell stop`, `mesh cell default` and `mesh cell forget` stay on this computer | your CLI sign-in, the cell and its new name | only after your yes and Claude Code's question |
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
  `/a4sx:profiles`, `/a4sx:mesh`, `/a4sx:mesh-manage` and `/a4sx:cell` use the CLI, so they need this
  sign-in, as do the CLI parts of `/a4sx:library` and `/a4sx:acquire`. Meshes, cells and launch
  profiles are available through the CLI only, not through the MCP sign-in.

## What needs which sign-in

| | No sign-in | MCP sign-in (`/mcp`) | CLI sign-in (`a4sx login`) |
|---|---|---|---|
| Search the marketplace, read summaries | MCP `search_sessions`, `get_session_summary`; CLI `a4sx search` | same | same |
| Search and list your own library | | MCP `search_sessions` with `scope=library` | `a4sx list` |
| Save this session | | MCP `publish_session` (a summary, or a transcript up to 2 MiB) | `a4sx push`, used by `/a4sx:publish` |
| Add a free listing to your library | | MCP `acquire_session` | `a4sx acquire` |
| Start a purchase of a paid listing (you pay in the browser) | | MCP `request_purchase`, `get_purchase_request` | |
| Load a library session as context into this conversation | | MCP `fetch_session_context` | |
| Suggest listing fields for one of your sessions | | MCP `suggest_listing_draft` | |
| Delete a saved session | | | `a4sx delete` |
| Continue a session | | | `a4sx launch --a4sx-session`, with `--seed-only` for Claude Code's history |
| Launch profiles | | | `a4sx profiles`, `a4sx profile` |
| Meshes and cells | | | `a4sx mesh …`, used by `/a4sx:mesh`, `/a4sx:mesh-manage` and `/a4sx:cell` |
| World-Sims | MCP `list_world_sim_templates` | MCP `list_my_modules`, `get_world_sim_access` | |

A tool that needs more access than you approved answers that it needs it; Claude Code may then
ask you to approve again in the browser. If it doesn't, sign in again from `/mcp`, or use the
CLI for that step.

Only **Claude Code** sessions can be continued today. Sessions recorded with other agents
(Codex CLI, Gemini CLI, OpenCode) show up in search, but you can only view them on the web.

## What gets uploaded

`/a4sx:save-summary` uploads only the markdown summary you approved. `/a4sx:publish` uploads this
session's transcript: the JSONL file Claude Code keeps under
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
  the `a4sx launch` command. `/a4sx:context` loads one as reference material here, which is not the
  same as resuming it.
- **Cells start in a terminal.** `a4sx launch --cell` starts its own Claude Code session, so
  `/a4sx:cell` gives you the command instead of running it.
- **Joining or leaving a mesh and allowing peers** are left to your own terminal, on purpose.
- **Editing a launch profile's model, server, headers, flags or env** prints the whole profile, so
  the plugin gives you the `a4sx profile` command for your terminal instead.
- **Folders, renaming and tags** in your library are not managed by this plugin; the a4sx web app
  and the a4sx VS Code extension manage them.
- **Publishing publicly** and **rating** a session are web-app steps. Neither the CLI nor MCP lists
  a session publicly or submits a rating.
- **Paying** happens only in your browser. No tool pays.
- **Large sessions over MCP.** `publish_session` takes up to 2 MiB, so `/a4sx:save-summary` saves a
  summary; full transcripts go through the CLI (`/a4sx:publish`).

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
