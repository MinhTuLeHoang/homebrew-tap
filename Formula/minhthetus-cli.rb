class MinhthetusCli < Formula
  desc "A professional, high-performance CLI for developer productivity"
  homepage "https://github.com/MinhTuLeHoang/minhthetus-cli"
  url "https://github.com/MinhTuLeHoang/minhthetus-cli/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "cddd299ad574e6d6961785ba7b87b508d23ade0c93deee89c6d31f2b1f0d3654"
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
