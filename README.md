# a4sx plugin for Claude Code

[a4sx](https://session-exchange.com) is a library and marketplace for coding-agent sessions. This
plugin brings it into Claude Code:

- **Save** the current Claude Code session to your private a4sx library.
- **Search** sessions other people have published.
- **Continue** a session: add it to your library and pick it up in a new local Claude Code session.

This repository is both a plugin marketplace named `a4sx` and the plugin `a4sx` itself.

## Install

```
/plugin marketplace add crossvault/a4sx-claude-plugins
/plugin install a4sx@a4sx
```

Saving and continuing sessions also need the official a4sx CLI. Install it in a terminal (it needs
`python3` and `curl`), then sign in:

```sh
curl -fsSL https://session-exchange.com/install.sh | sh
a4sx login
```

`a4sx login` opens a browser device sign-in and stores the session in
`~/.config/a4sx/session` (mode 600). The plugin never asks for a token and never writes one to a file.

## Commands

| Command | What it does | a4sx interface it uses |
|---|---|---|
| `/a4sx:search <query>` | Searches published marketplace sessions, or your own library once you are signed in. Your query is sent to session-exchange.com; Claude Code asks first unless the tool is already allowed or permission prompts are bypassed. | MCP tools `search_sessions` and `get_session_summary` (marketplace: no sign-in; your library: MCP sign-in) |
| `/a4sx:publish [title]` | Saves this session to your **private** library. Shows a scrub preview and asks before uploading. | CLI `a4sx push --dry-run`, then `a4sx push` |
| `/a4sx:resume <listing-id>` | Adds a listing to your library and tells you how to continue it. | MCP `get_session_summary`, CLI `a4sx acquire`, then you run `a4sx launch --a4sx-session <id>` |
| `/a4sx:help` | Explains a4sx and the commands. Claude also uses it on its own when you mention a4sx. | Points Claude at the agent brief `https://session-exchange.com/orient` |

The plugin also registers the hosted a4sx MCP server, `https://session-exchange.com/mcp`, as `a4sx`
(see `/mcp`). If you already added the same server yourself with `claude mcp add`, Claude Code
connects once and uses your entry, not the plugin's. The skills' pre-approved tool names then don't
match, so Claude asks for permission on every call. To let the plugin's skills use their
pre-approved tools, remove your own entry with `claude mcp remove <name>`, using the name you gave
it (`claude mcp list` shows it).

`/a4sx:publish` and `/a4sx:resume` only run when you type them. Claude does not start an upload on
its own.

## Services contacted outside the MCP connector

The declared connector is the MCP server `https://session-exchange.com/mcp`. Some skills also reach
the same first-party service, session-exchange.com, by other routes. No other service is contacted.

| Skill | Route | What is sent | When |
|---|---|---|---|
| `/a4sx:publish` | the official a4sx CLI (`a4sx push`) to the session-exchange.com API | this session's transcript, scrubbed on your machine first, plus the title you choose | only after a `a4sx push --dry-run` preview, and only after Claude Code asks you: the upload is not pre-approved |
| `/a4sx:resume` | the a4sx CLI (`a4sx acquire`, then you run `a4sx launch`) to the session-exchange.com API | the listing or session id you chose, and your CLI sign-in | `a4sx acquire` only after Claude Code asks you (it is not pre-approved); `a4sx launch` you run yourself |
| `/a4sx:help` | WebFetch, limited to `session-exchange.com`, reading `https://session-exchange.com/orient` | nothing about you: a read of the public agent brief | when Claude needs the brief |
| `/a4sx:publish`, `/a4sx:resume` | the CLI installer `https://session-exchange.com/install.sh` | nothing: a download | only if you run the installer yourself; the skills never run it |

## Sign in

There are two ways to sign in. They are independent; use either or both.

- **MCP sign-in, from Claude Code.** Run `/mcp`, select the plugin's `a4sx` server and choose to
  authenticate. Claude Code opens the a4sx sign-in in your browser (GitHub or Google), then a
  consent page that names the client, the access it asks for and how long it lasts. After you approve,
  Claude Code holds the access itself; you never copy a token. You can see and revoke the connection
  under Account › Agent keys on session-exchange.com.
- **CLI sign-in, in a terminal.** `a4sx login`, as above. `/a4sx:publish` and `/a4sx:resume` use the
  CLI, so they need this sign-in.

## What needs which sign-in

| | No sign-in | MCP sign-in (`/mcp`) | CLI sign-in (`a4sx login`) |
|---|---|---|---|
| Search the marketplace, read summaries | MCP `search_sessions`, `get_session_summary` | same | |
| Search your own library | | MCP `search_sessions` with `scope=library` | `a4sx list` |
| Save this session | | MCP `publish_session` (up to 2 MiB) | `a4sx push`, used by `/a4sx:publish` |
| Add a listing to your library | | MCP `acquire_session` | `a4sx acquire`, used by `/a4sx:resume` |
| Load a library session as context into this conversation | | MCP `fetch_session_context` | |
| Continue a session | | | `a4sx launch --a4sx-session`, in a new Claude Code session |

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

These are things the plugin does not do, because no a4sx interface for them exists yet:

- **No CLI search.** The CLI has no marketplace search, so search goes through MCP only.
- **Continuing needs a new session.** `a4sx launch` starts a new Claude Code session, so a session
  can't be continued inside the current one. With MCP sign-in, `fetch_session_context` can load one
  as context here, which is not the same as resuming it.
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
