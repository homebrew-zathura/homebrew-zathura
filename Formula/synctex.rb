class Synctex < Formula
  desc "Parser libary for synctex"
  homepage "https://github.com/jlaurens/synctex"
  url "https://github.com/jlaurens/synctex", using: :git, revision: "d37a5a59091b6a1bda387e68dd9431a7a750f419", branch: "2024"
  version "2024"
  # sha256 "a6571bf8cce8cff50dd5e29cbe78ae6f1c2c32d132604aa7ba11e4114c9dc981"
  license "MIT"
  head "https://github.com/jlaurens/synctex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d{4})$/i)
  end

  depends_on "pkgconf" => :test
  depends_on "zlib"

  def install
    flags = ["-Wall", "-I.", "-lz", "-shared"]
    flags += ["-fPIC"] if OS.linux?
    system ENV.cc.to_s, *flags, "synctex_parser.c", "synctex_parser_utils.c", "-o", "libsynctex.dylib"

    lib.install "libsynctex.dylib"
    mkdir "#{include}/synctex"
    cp "synctex_parser.h", "#{include}/synctex/"
    cp "synctex_parser_utils.h", "#{include}/synctex/"
    cp "synctex_version.h", "#{include}/synctex/"

    open("synctex.pc.in", "w") do |file|
      file.puts "prefix=#{prefix}
exec_prefix=#{prefix}
libdir=#{lib}
includedir=#{include}

Name: synctex
Description: SyncTeX parser library
Version: 2.0.0
Requires.private: zlib
Libs: -L${libdir} -lsynctex
Cflags: -I${includedir}"
    end

    mkdir "#{lib}/pkgconfig"
    cp "synctex.pc.in", "#{lib}/pkgconfig/synctex.pc"
  end

  test do
    system "pkgconf", "--atleast-version=2", "synctex"
    assert_match "-I#{include}", shell_output("pkgconf --cflags synctex")

    (testpath/"test.c").write <<~C
      #include <stddef.h>
      #include <synctex/synctex_parser.h>

      int main(void) {
        synctex_scanner_p scanner = synctex_scanner_new_with_output_file("missing.pdf", NULL, 1);
        if (scanner != NULL) {
          synctex_scanner_free(scanner);
        }
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags synctex").split
    system ENV.cc, "test.c", *flags, "-c", "-o", "test.o"
  end
end
