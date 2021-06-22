class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/21.04.2/src/kcachegrind-21.04.2.tar.xz"
  sha256 "434e7bfdc04b57213ba868d63a80e3db4ac0afc8e0b9454870573430b58b1cd0"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f28aa5ecee50b1b767216e7b85b2115c8bb968222cca584e80ff49c2f2154712"
    sha256 cellar: :any, big_sur:       "2bb517d6b2d8f6e3908c786f4dd9ef91f380365a9130919e53c682373593aa4c"
    sha256 cellar: :any, catalina:      "2f497b14da578cdc0d7ad8540e9bddc408ff4e834a2dbbc351805ce7c0a4fce4"
    sha256 cellar: :any, mojave:        "b264c802f226527d8261fa162edd216f9a7372c7fe3fc5aaf43e0db9b165836e"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  def install
    spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
    spec << "-arm64" if Hardware::CPU.arm?
    cd "qcachegrind" do
      system "#{Formula["qt@5"].opt_bin}/qmake", "-spec", spec,
                                               "-config", "release"
      system "make"

      on_macos do
        prefix.install "qcachegrind.app"
        bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
      end

      on_linux do
        bin.install "qcachegrind/qcachegrind"
      end
    end
  end
end
