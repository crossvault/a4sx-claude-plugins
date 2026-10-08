# Security

## Reporting a vulnerability

Please report security problems privately, not in a public issue. Use the contact details on
https://session-exchange.com/contact and say that it is a security report.

This covers this plugin and the a4sx service it talks to (the MCP server at
`https://session-exchange.com/mcp` and the `a4sx` CLI).

Please include what you found, how to reproduce it, and the plugin version (`version` in
`plugins/a4sx/.claude-plugin/plugin.json`). Don't include real tokens or other people's data.

## What this plugin does with credentials

The plugin holds no credentials. It registers the MCP server by URL only, with no headers. Sign-in
happens in the official `a4sx` CLI (`a4sx login`) or, once it is live, in Claude Code's own MCP
sign-in. The plugin's instructions tell Claude never to ask for a token in the chat and never to
write one to a file.
