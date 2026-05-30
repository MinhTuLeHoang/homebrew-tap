class MinhthetusCli < Formula
  desc "A professional, high-performance CLI for developer productivity"
  homepage "https://github.com/MinhTuLeHoang/minhthetus-cli"
  url "https://github.com/MinhTuLeHoang/minhthetus-cli/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "34b0f973f947af4a173dfea9504ce6b317c454338abf34fdc97649c2fc6667e0"
  license "ISC"

  depends_on "go" => :build

  def install
    # Inject the version and current build date during compilation
    build_date = Time.now.strftime("%Y-%m-%d")
    ldflags = "-s -w -X github.com/MinhTuLeHoang/minhthetus-cli/cmd.Version=v#{version} -X github.com/MinhTuLeHoang/minhthetus-cli/cmd.BuildDate=#{build_date}"

    system "go", "build", "-ldflags", ldflags, "-o", "minhthetus-cli", "main.go"
    
    bin.install "minhthetus-cli"

    # Generate and install shell completions natively
    (bash_completion/"minhthetus-cli").write `#{bin}/minhthetus-cli completion bash`
    (zsh_completion/"_minhthetus-cli").write `#{bin}/minhthetus-cli completion zsh`
    (fish_completion/"minhthetus-cli.fish").write `#{bin}/minhthetus-cli completion fish`
  end

  test do
    assert_match "version v#{version}", shell_output("#{bin}/minhthetus-cli --version")
  end
end
