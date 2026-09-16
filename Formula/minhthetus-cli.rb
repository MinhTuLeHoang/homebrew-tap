class MinhthetusCli < Formula
  desc "A professional, high-performance CLI for developer productivity"
  homepage "https://github.com/MinhTuLeHoang/minhthetus-cli"
  url "https://github.com/MinhTuLeHoang/minhthetus-cli/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "ab78f7ce1848ecfbe73bd1c9ef1b45f18d094fd3088d2f5f266f00dd2be87aed"
  license "ISC"

  depends_on "go" => :build

  def install
    # Inject the version and current build date during compilation
    build_date = Time.now.strftime("%Y-%m-%d")
    ldflags = "-s -w -X github.com/MinhTuLeHoang/minhthetus-cli/cmd.Version=v#{version} -X github.com/MinhTuLeHoang/minhthetus-cli/cmd.BuildDate=#{build_date}"

    system "go", "build", "-ldflags", ldflags, "-o", "minhthetus-cli", "main.go"
    
    bin.install "minhthetus-cli"

    # Generate and install shell completions natively
    generate_completions_from_executable(bin/"minhthetus-cli", "completion")
  end

  def caveats
    <<~EOS
      To enable autocompletion automatically, please run minhthetus-cli once:
        minhthetus-cli

      If that does not work, you can force setting it up:
        minhthetus-cli setup-completion

      Then restart your terminal or run:
        source ~/.zshrc (for Zsh) or source ~/.bashrc (for Bash)
    EOS
  end

  test do
    assert_match "version v#{version}", shell_output("#{bin}/minhthetus-cli --version")
  end
end
