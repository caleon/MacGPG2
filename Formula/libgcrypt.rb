require 'formula'

class Libgcrypt < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.5.0.tar.bz2'
  sha1 '3e776d44375dc1a710560b98ae8437d5da6e32cf'
  homepage 'http://directory.fsf.org/project/libgcrypt/'

  depends_on 'pth'
  depends_on 'libgpg-error'
  
  keep_install_names true
  
  def patches
    if ENV.compiler == :clang
      { :p0 => ["https://trac.macports.org/export/85232/trunk/dports/devel/libgcrypt/files/clang-asm.patch",
                "#{HOMEBREW_PREFIX}/Library/Formula/Patches/IDEA.patch"]}
    else
      { :p0 => ["#{HOMEBREW_PREFIX}/Library/Formula/Patches/IDEA.patch"]}
    end
  end

  def install
    ENV.build_32_bit
    #ENV.universal_binary	# build fat so wine can use it
    
    ENV.append 'CFLAGS', "-fheinous-gnu-extensions -std=gnu89" if ENV.compiler == :clang
    ENV.prepend 'LDFLAGS', '-headerpad_max_install_names'
    ENV.prepend 'LDFLAGS', "-Wl,-rpath,@loader_path/../lib -Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    # # Set the correct loader_path so the test files can find the libgpg-error library.
    #     inreplace 'src/Makefile.in' do |s|
    #       s.change_make_var! "GPGT_LOADER_PATH", "\"-Wl,-rpath,@loader_path/../lib -Wl,-rpath,#{HOMEBREW_PREFIX}/lib\""
    #     end
    #     inreplace 'tests/Makefile.in' do |s|
    #       s.change_make_var! "GPGT_LOADER_PATH", "\"-Wl,-rpath,@loader_path/../lib -Wl,-rpath,#{HOMEBREW_PREFIX}/lib\""
    #     end
    #     
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{HOMEBREW_PREFIX}",
                          "--with-pth-prefix=#{HOMEBREW_PREFIX}",
                          "--enable-static=no", "--disable-maintainer-mode",
                          "--disable-aesni-support"
    # Separate steps, or parallel builds fail
    system "make"
    system "make check"
    system "make install"
  end
end

__END__
