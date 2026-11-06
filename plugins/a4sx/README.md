# a4sx

Claude Code plugin for [a4sx](https://session-exchange.com), a library and marketplace for
coding-agent sessions.

```
/plugin marketplace add crossvault/a4sx-claude-plugins
/plugin install a4sx@a4sx
```

- `/a4sx:search <query>`: search published sessions (MCP, no sign-in), or your own library.
- `/a4sx:acquire <listing-id>`: add a free listing to your library, or start a purchase that you
  confirm and pay for in your browser (MCP).
- `/a4sx:publish [title]`: save this session to your private library (official `a4sx` CLI).
- `/a4sx:save-summary [title]`: save a summary of this session that you approve (MCP, no CLI).
- `/a4sx:library …`: list, show and delete saved sessions, suggest listing fields, sign out.
- `/a4sx:context <library-id>`: load a library session here as reference material (MCP).
- `/a4sx:resume <id>`: continue a session, here or in a terminal (CLI).
- `/a4sx:profiles …`: list your launch profiles; copy, set the default or delete one (CLI).
- `/a4sx:setup`: check, install or update the `a4sx` CLI, and sign in to it.
- `/a4sx:mesh [mesh]`: show your meshes, members, peers, requests, invites and this computer's
  cells (CLI, read-only).
- `/a4sx:mesh-manage …`: create a mesh, manage invites and join requests, set a mesh's policy,
  manage this computer's cells (CLI, each after your yes).
- `/a4sx:cell`: get the command that runs a session as a cell in one of your meshes.
- `/a4sx:world-sim`: World-Sim templates, your World-Sims and how to get access (MCP, read-only).
- `/a4sx:help`: what a4sx is and which command to use.

Examples: "Save this session to my a4sx library", "Has anyone published a session that migrates a
Django app to async views?", "Which a4sx meshes am I in, and which of my cells are running?".

The plugin registers the hosted MCP server `https://session-exchange.com/mcp` as `a4sx`. Searching
the marketplace needs no sign-in. To search your own library and use the other account tools over
MCP, sign in from Claude Code: run `/mcp`, select the `a4sx` server and choose to authenticate.
Uploads, purchase requests and changes run only after you say yes, and payment happens only in your
browser; joining or leaving a mesh and allowing peers stay in your own terminal. The plugin has no
hooks.

Install, sign-in, what gets uploaded, the services contacted and the limits of the privacy scrub
are described in the [repository README](https://github.com/crossvault/a4sx-claude-plugins#readme).
