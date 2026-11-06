# a4sx

Claude Code plugin for [a4sx](https://session-exchange.com), a library and marketplace for
coding-agent sessions.

```
/plugin marketplace add crossvault/a4sx-claude-plugins
/plugin install a4sx@a4sx
```

- `/a4sx:search <query>`: search published sessions (MCP, no sign-in), or your own library.
- `/a4sx:publish [title]`: save this session to your private library (official `a4sx` CLI).
- `/a4sx:resume <id>`: add a listing to your library and continue it, here or in a terminal (CLI).
- `/a4sx:setup`: check, install or update the `a4sx` CLI, and sign in to it.
- `/a4sx:mesh [mesh]`: show your meshes, their peers and this computer's cells (CLI, read-only).
- `/a4sx:mesh-manage …`: create a mesh or an invite, set a mesh's policy, rename or stop a cell
  (CLI, each after your yes).
- `/a4sx:cell`: get the command that runs a session as a cell in one of your meshes.
- `/a4sx:help`: what a4sx is and which command to use.

Examples: "Save this session to my a4sx library", "Has anyone published a session that migrates a
Django app to async views?", "Which a4sx meshes am I in, and which of my cells are running?".

The plugin registers the hosted MCP server `https://session-exchange.com/mcp` as `a4sx`. Searching
the marketplace needs no sign-in. To search your own library and use the other account tools over
MCP, sign in from Claude Code: run `/mcp`, select the `a4sx` server and choose to authenticate.
Uploads and changes run only after you say yes; joining a mesh and allowing peers stay in your own
terminal. The plugin has no hooks.

Install, sign-in, what gets uploaded, the services contacted and the limits of the privacy scrub
are described in the [repository README](https://github.com/crossvault/a4sx-claude-plugins#readme).
