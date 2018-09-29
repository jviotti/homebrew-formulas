# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
class I386ElfBinutils < Formula
  desc "GNU Binutils for i386-elf"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.gz"
  url "http://ftpmirror.gnu.org/gnu/binutils/binutils-2.24.tar.gz"
  version "2.24"
  sha256 "4930b2886309112c00a279483eaef2f0f8e1b1b62010e0239c16b22af7c346d4"

  depends_on "gcc@8" => :build

  def install
    ENV["CC"] = "#{Formula["gcc@8"].bin}/gcc-8"
    system "./configure", "--disable-werror",
                          "--target=i386-elf",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/i386-elf-ld", "-v"
  end
end
