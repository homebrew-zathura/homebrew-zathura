class ZathuraDjvu < Formula
  desc "DJVU plugin for zathura"
  homepage "https://pwmt.org/projects/zathura-djvu/"
  url "https://github.com/pwmt/zathura-djvu/archive/refs/tags/2026.01.30.tar.gz"
  sha256 "dbfc85bc31a9cae21f8157944d27a2119675ab52e6540e9f9b1506a9ed8a4dc9"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "zathura"

  def install
    inreplace "meson.build", "zathura.get_variable(pkgconfig: 'plugindir')", "'#{prefix}'"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def caveats
    <<-EOS
      To enable this plugin you will need to link it in place.
      First create the plugin directory if it does not exist yet:
        $ mkdir -p $(brew --prefix zathura)/lib/zathura
      Then link the .dylib to the directory:
        $ ln -s $(brew --prefix zathura-djvu)/libdjvu.dylib $(brew --prefix zathura)/lib/zathura/libdjvu.dylib

      More information as to why this is needed: https://github.com/zegervdv/homebrew-zathura/issues/19
    EOS
  end

  test do
    system "true"
  end
end
