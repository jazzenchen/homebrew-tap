# Homebrew tap for Agent HUD

[Agent HUD](https://github.com/jazzenchen/agent-hud-open) puts your coding agents' quotas, tokens and live sessions at the edge of your screen.

```sh
brew install --cask jazzenchen/tap/agent-hud
```

macOS 14 or later, on Apple silicon or Intel. The cask installs the newest release, betas included.

Agent HUD updates itself, so `brew upgrade` leaves it alone; `brew upgrade --greedy` reinstalls it from the cask. `brew uninstall --cask agent-hud` removes the app, and `--zap` also removes its data.

A workflow moves the cask to each new release of [agent-hud-open](https://github.com/jazzenchen/agent-hud-open/releases) within six hours.
