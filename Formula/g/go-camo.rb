class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "1aa9a052cd787da3bddbaed90c67210df72b4a615daa79488eac63b8d5beeac9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8297d5c62f4af59faf35fc08ab9e962d55844e8d65f318288ddd1f70671293cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8297d5c62f4af59faf35fc08ab9e962d55844e8d65f318288ddd1f70671293cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8297d5c62f4af59faf35fc08ab9e962d55844e8d65f318288ddd1f70671293cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4ae71ec347ac1391a6de1fa95459ce9907f062f6186227e9aa34fe12398a29f"
    sha256 cellar: :any_skip_relocation, ventura:        "b4ae71ec347ac1391a6de1fa95459ce9907f062f6186227e9aa34fe12398a29f"
    sha256 cellar: :any_skip_relocation, monterey:       "b4ae71ec347ac1391a6de1fa95459ce9907f062f6186227e9aa34fe12398a29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b816af317b3a6c06a50e570d82ac3e78d340e5eb1d176eb9d578961be01f8e9"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "APP_VER=#{version}"
    bin.install Dir["build/bin/*"]
  end

  test do
    port = free_port
    fork do
      exec bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "http://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
