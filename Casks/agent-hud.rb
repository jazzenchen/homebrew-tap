cask "agent-hud" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.12"
  sha256 arm:   "9d6b593f4f8a955133b1050b7ad65ea9023351faeef85ab26f3c13bf86fe0ce3",
         intel: "6b4b8f0aa19cbe83a7b06d323d84e55f03e7e5c4ed899348e176ffb79070fdff"

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
