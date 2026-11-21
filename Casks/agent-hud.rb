cask "agent-hud" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.11"
  sha256 arm:   "0c721e3e182d85a3e7348162f015b71f6056ca1a0c6d14bdedc2820e16271615",
         intel: "50c2723c33cab87eacfe85de28d5383d375d87835c5aa6cb99a48686778b0fee"

  url "https://github.com/jazzenchen/agent-hud-open/releases/download/v#{version}/Agent-HUD-#{version}-#{arch}.dmg"
  name "Agent HUD"
  desc "Quotas, tokens and live sessions of AI coding agents at the screen's edge"
  homepage "https://agenthud.app/"

  # Betas count: the cask follows the newest release, pre-release or not.
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        release["tag_name"]&.[](regex, 1)
      end
    end
  end

  # The app updates itself; .github/workflows/bump.yml moves this file to each new release.
  auto_updates true
  depends_on macos: :sonoma

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
