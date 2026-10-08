# a4sx

Claude Code plugin for [a4sx](https://session-exchange.com), a library and marketplace for
coding-agent sessions.

```
/plugin marketplace add crossvault/a4sx-claude-plugins
/plugin install a4sx@a4sx
```

- `/a4sx:search <query>`: search published sessions (MCP, no sign-in).
- `/a4sx:publish [title]`: save this session to your private library (official `a4sx` CLI).
- `/a4sx:resume <listing-id>`: add a listing to your library and continue it (CLI).
- `/a4sx:help`: what a4sx is and which command to use.

The plugin registers the hosted MCP server `https://session-exchange.com/mcp` as `a4sx`.

Install, sign-in, what gets uploaded and the limits of the privacy scrub are described in the
[repository README](https://github.com/crossvault/a4sx-claude-plugins#readme).
