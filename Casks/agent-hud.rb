cask "agent-hud" do
  arch arm: "arm64", intel: "x86_64"

  version "0.6.0-beta.8"
  sha256 arm:   "a8640524cddf6839796924a02580ad622dca5d7da0ef5b17ed44247dddb92dda",
         intel: "bfb0558e78dc029b18abed3500a7aa3bcaec5c403818554a59ac4537329f9259"

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
