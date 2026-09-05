# NixOS guidelines

- Use modern `nix` commands and flakes; do not use legacy `nix-*` commands or channels.
- Do not run expensive `find` operations under `/nix/store`. Use `nix shell`/`nix run`, or evaluate a Nix expression to locate a binary—whichever is most efficient.
- Prefer the flake’s existing checks, formatters, and development shells when available.
- Always use `sops-nix` for secret management; do not place secrets in plaintext Nix, flakes, or repository files.
- Use `colmena apply --verbose --build-on-target` for remote SSH activations; do not use `nixos-rebuild` for deployments. `--verbose` avoids GUI-spinner output polluting context, and `--build-on-target` saves local disk space.
- Be space-conscious with Nix: never build large system closures locally on a development laptop; evaluation succeeding is usually sufficient unless a build is explicitly required.
- If SSH reports `agent refused a signing operation` for a key beginning with `cardno:`, stop immediately: gpg-agent is timing out because the hardware token was not tapped. Ask the user to tell you to retry and tap the token.

# GitLab instance guidelines

- This project is hosted on `git.tdude.co` at `tristan/infrastructure`. Use `glab` for GitLab API and CI tasks.
- `gh` remains appropriate for searching and interacting with GitHub; use `glab auth status --hostname git.tdude.co` when querying or changing GitLab state.
