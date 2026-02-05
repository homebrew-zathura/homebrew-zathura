class Girara < Formula
  desc "Interface library"
  homepage "https://pwmt.org/projects/girara/"
  url "https://github.com/pwmt/girara/archive/refs/tags/2026.02.03.tar.gz"
  sha256 "ccebf30c2a551f9e8f08e5e386c409aa5dfb75a8e2a19f75b36539e0a847eb74"
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
