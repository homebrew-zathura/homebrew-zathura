class ZathuraCb < Formula
  desc "Comic book plugin for zathura"
  homepage "https://pwmt.org/projects/zathura-cb/"
  url "https://github.com/pwmt/zathura-cb/archive/refs/tags/2026.02.03.tar.gz"
  sha256 "d04887cf29b7e635efb4a4a3316e4f032435611445f20940f7f0e288cee20576"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive"
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
        $ ln -s $(brew --prefix zathura-cb)/libcb.dylib $(brew --prefix zathura)/lib/zathura/libcb.dylib

      More information as to why this is needed: https://github.com/zegervdv/homebrew-zathura/issues/19
    EOS
  end

  test do
    system "true" # TODO
  end
end
