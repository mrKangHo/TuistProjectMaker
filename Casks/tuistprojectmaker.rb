cask "tuistprojectmaker" do
  version "0.1.0"
  sha256 "0afde27b44be73c9f01f4a9fa7212d06d890e7d0a9f0fc9025a8d12dc821055f"

  url "https://github.com/mrKangHo/TuistProjectMaker/releases/download/v#{version}/TuistProjectMaker-#{version}-macos.zip"
  name "TuistProjectMaker"
  desc "GUI wizard that scaffolds Tuist-based Clean Architecture iOS projects"
  homepage "https://github.com/mrKangHo/TuistProjectMaker"

  app "TuistProjectMaker.app"

  postflight do
    system_command "/usr/bin/xattr",
                    args: ["-dr", "com.apple.quarantine", "#{appdir}/TuistProjectMaker.app"],
                    sudo: false
  end

  zap trash: [
    "~/Library/Preferences/com.example.TuistProjectMaker.plist",
  ]
end
