class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://github.com/lampepfl/dotty/releases/download/3.5.0/scala3-3.5.0.tar.gz"
  sha256 "bacad178623f1940dae7d75c54c75aaf53f14f07ae99803be730a1d7d51a612d"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9bc4c1eefa68cdb4b9f01fbd21296ea579a0f6dc8a1f78cfba625494cb49560"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3f22ca7949354f01ca6513cb7cb41e2300805c7c439fbe11ba5b919be34f2bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe398060d782c37d4a851cf41663a701e5d6f450b26168f999e0aa81b1627330"
    sha256 cellar: :any_skip_relocation, sonoma:         "a079e73558095bade0b25c37a7495c858d6b77e854bc9dc3a76d196cca07853b"
    sha256 cellar: :any_skip_relocation, ventura:        "13d4ba4f872971a7b43437091d5f887fe79af4decaa3acfd7609a9916beb0e07"
    sha256 cellar: :any_skip_relocation, monterey:       "3cc745af73dee67fb6362cfb9ed97b115d3453b061f38b30d3bd04b54fb2b676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f60a74e344a241c429b07d46554dfec6878b2a921895f67c91d38940f7971d98"
  end

  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `common` binaries"

  def install
    rm Dir["bin/*.bat"]
    libexec.install "lib"
    libexec.install "maven2"
    libexec.install "VERSION"
    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"lib"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala #{file}").strip

    assert_equal "4", out
  end
end
