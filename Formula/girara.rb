class Girara < Formula
  desc "Interface library"
  homepage "https://pwmt.org/projects/girara/"
  url "https://github.com/pwmt/girara/archive/refs/tags/2026.01.30.tar.gz"
  sha256 "f4bfacafe7ecbea14fd2cafac96d5874093487f69c50c0d3d27a5fa2f71cc3b5"
  license "Zlib"
  head "https://github.com/pwmt/girara.git", branch: "develop"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cmake"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "json-c"
  depends_on "json-glib"
  depends_on "libnotify"
  depends_on "libpthread-stubs"

  def install
    inreplace "girara/utils.c" do |s|
      # s.gsub!(/xdg-open/, "open")
      s.gsub!("xdg-open", "open")
    end
    # Set HOMBREW_PREFIX
    ENV["CMAKE_INSTALL_PREFIX"] = prefix

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "true" # TODO
  end
end
