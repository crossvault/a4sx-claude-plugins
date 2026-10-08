# Changelog

All notable changes to this project are listed here. Versions follow
[Semantic Versioning](https://semver.org/).

## [0.1.0] - unreleased

### Added

- Marketplace `a4sx` with the plugin `a4sx`.
- The hosted a4sx MCP server `https://session-exchange.com/mcp`, registered as `a4sx`.
- `/a4sx:search`: search published sessions through MCP, no sign-in.
- `/a4sx:publish`: save the current session to the private library with the official `a4sx` CLI,
  after a scrub preview and the user's go-ahead.
- `/a4sx:resume`: add a listing to the library with `a4sx acquire` and continue it with
  `a4sx launch --a4sx-session`.
- `/a4sx:help`: explains a4sx and points Claude at the `/orient` agent brief.
- `scripts/validate.sh` and a GitHub Actions workflow that runs it (`claude plugin validate --strict`).
