class ZathuraCb < Formula
  desc "Comic book plugin for zathura"
  homepage "https://pwmt.org/projects/zathura-cb/"
  url "https://github.com/pwmt/zathura-cb/archive/refs/tags/0.1.12.tar.gz"
  sha256 "be3efb8e836fa1874e156c6143927fc6ca8b35088412e75d4cc5543ce42b42e0"
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
