class Zathura < Formula
  desc "PDF viewer"
  homepage "https://pwmt.org/projects/zathura/"
  url "https://github.com/pwmt/zathura/archive/refs/tags/2026.02.09.tar.gz"
  sha256 "ee890591608a79e75e9719054c4f29c4a611172484e93e43126651d3d5cd9477"
  license "Zlib"
  head "https://github.com/pwmt/zathura.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "adwaita-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "gettext"
  depends_on "girara"
  depends_on "glib"
  depends_on "intltool"
  depends_on "json-glib"
  depends_on "libmagic"
  depends_on "synctex" => :optional
  on_macos do
    depends_on "gtk+3"
    depends_on "gtk-mac-integration"
  end

  patch do
    url "file://#{__dir__}/../patches/mac-integration.diff"
    sha256 "8c8b1546d18418c1c43579365bd810a022b30c655edc60364d1867ee4b3ba00f"
  end

  on_macos do
    option "with-no-titlebar", "Remove the title bar on macOS"

    if build.with? "no-titlebar"
      # Optionally remove the title bar on macOS with the "-T" or "--no-titlebar" arguments
      patch do
        url "file://#{__dir__}/../patches/no-titlebar.diff"
        sha256 "c95c2ed65a412ab4199ef238ca1507a0988821596daaa00294bb27bd925dd6fe"
      end
    end
    
  end

  def install
    # Set Homebrew prefix
    ENV["PREFIX"] = prefix
    # Add the pkgconfig for girara to the PKG_CONFIG_PATH
    # TODO: Find out why it is not added correctly for Linux
    ENV["PKG_CONFIG_PATH"] = "#{ENV["PKG_CONFIG_PATH"]}:#{Formula["girara"].prefix}/lib/x86_64-linux-gnu/pkgconfig"

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def caveats
    <<~EOS
      Zathura is, by default, only a command line tool. To use it as an app with a .app file, run:
        (curl https://raw.githubusercontent.com/homebrew-zathura/homebrew-zathura/refs/heads/master/convert-into-app.sh | sh)
      If this does not work, try downloading the script from the repo and running it manually.
    EOS
  end
  test do
    assert_match "zathura", shell_output("#{bin}/zathura --version")
  end
end
