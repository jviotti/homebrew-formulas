# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
class I386ElfGcc < Formula
  desc "GNU GCC for i386-elf"
  homepage "https://www.gnu.org/software/gcc/gcc.html"
  url "https://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2"
  mirror "http://mirrors-usa.go-parts.com/gcc/releases/gcc-4.9.1/gcc-4.9.1.tar.bz2"
  version "4.7.1"
  sha256 "d334781a124ada6f38e63b545e2a3b8c2183049515a1abab6d513f109f1d717e"

  # It won't build with clang
  depends_on "gcc@8" => :build

  depends_on "gmp"
  depends_on "i386-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"

  def install

    # Build with gcc 8
    ENV["CC"] = "#{Formula["gcc@8"].bin}/gcc-8"
    ENV["CXX"] = "#{Formula["gcc@8"].bin}/g++-8"

    mkdir "build" do
      system "../configure", "--target=i386-elf",
                             "--disable-libssp",
                             "--enable-languages=c",
                             "--without-headers",
                             "--with-gmp=#{Formula["gmp"].opt_prefix}",
                             "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                             "--with-mpc=#{Formula["libmpc"].opt_prefix}",
                             "--prefix=#{prefix}"

      system "make", "all-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-gcc"
      system "make", "install-target-libgcc"

      # GCC needs this folder in #{prefix} in order to see the binutils.
      # It doesn't look for i386-elf-as on $PREFIX/bin. Rather, it looks
      # for as on $PREFIX/$TARGET/bin/ ($PREFIX/i386-elf/bin/as).
      binutils = Formula["i386-elf-binutils"].prefix
      FileUtils.ln_sf "#{binutils}/i386-elf", "#{prefix}/i386-elf"
    end
  end

  test do
    system "#{bin}/i386-elf-gcc", "--version"
    (testpath/"hello.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    system "#{bin}/i386-elf-gcc", "hello.c"
  end
end
