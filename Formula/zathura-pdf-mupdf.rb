class ZathuraPdfMupdf < Formula
  desc "MuPDF backend plugin for zathura"
  homepage "https://pwmt.org/projects/zathura-pdf-mupdf/"
  url "https://github.com/pwmt/zathura-pdf-mupdf/archive/refs/tags/0.4.6.tar.gz"
  sha256 "90bdc7c0d4b5f6bd7b17f9c3832ae5eb8465b45d78ab3b8c2fca26ed45ed1177"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "mupdf"
  depends_on "zathura"

  def install
    inreplace "meson.build", "zathura.get_variable(pkgconfig: 'plugindir')", "prefix"
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
        $ ln -s $(brew --prefix zathura-pdf-mupdf)/libpdf-mupdf.dylib $(brew --prefix zathura)/lib/zathura/libpdf-mupdf.dylib

      More information as to why this is needed: https://github.com/zegervdv/homebrew-zathura/issues/19
    EOS
  end

  test do
    system "true" # TODO
  end
end
