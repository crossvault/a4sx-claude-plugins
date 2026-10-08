# Contributing

Thanks for helping. Issues and pull requests are welcome.

## Before you open a pull request

1. Run `./scripts/validate.sh`. It must pass. With the `claude` CLI installed it also runs
   `claude plugin validate --strict` on the marketplace and the plugin, as CI does.
2. Follow the current Claude Code plugin format: https://code.claude.com/docs/en/plugins
3. Use only interfaces a4sx offers: the MCP server at `https://session-exchange.com/mcp` and the
   official `a4sx` CLI. Don't add code that uploads, transforms or scrubs transcripts; the CLI and
   the server do that.
4. Never commit a token, key or other credential, not even an example that looks real.
5. Add a line to `CHANGELOG.md`, and bump `version` in `plugins/a4sx/.claude-plugin/plugin.json`
   for a release. Installed copies only update when the version changes.

## Developer Certificate of Origin (DCO)

Every commit must be signed off. By signing off you certify the
[Developer Certificate of Origin 1.1](https://developercertificate.org/): that you wrote the change,
or otherwise have the right to submit it under this project's license (MIT).

Add the sign-off with `git commit -s`. It appends a line like this, which must match the commit
author:

```
Signed-off-by: Your Name <you@example.com>
```

To sign off commits you already made: `git rebase --signoff main`, then force-push your branch.
