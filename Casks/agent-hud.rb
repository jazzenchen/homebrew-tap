cask "agent-hud" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.0-beta.6"
  sha256 arm:   "74f0ad0bbdefa48784304a6a8fa1331334312d4fec3298c056a5b121e07f1df2",
         intel: "26e4e0c8659aecc934d5aead813ad811433bca86decc520ee50b2c20dd19f7e4"

  url "https://github.com/jazzenchen/agent-hud-open/releases/download/v#{version}/Agent-HUD-#{version}-#{arch}.dmg",
      verified: "github.com/jazzenchen/agent-hud-open/"
  name "Agent HUD"
  desc "Quotas, tokens and live sessions of AI coding agents at the screen's edge"
  homepage "https://agenthud.app/"

  # The app updates itself; .github/workflows/bump.yml moves this file to each new release.
  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Agent HUD.app"

  uninstall quit: "app.agenthud.mac"

  zap trash: [
    "~/Library/Application Support/app.agenthud.mac",
    "~/Library/Caches/app.agenthud.mac",
    "~/Library/HTTPStorages/app.agenthud.mac",
    "~/Library/HTTPStorages/app.agenthud.mac.binarycookies",
    "~/Library/Preferences/app.agenthud.mac.plist",
    "~/Library/WebKit/app.agenthud.mac",
  ]
end
