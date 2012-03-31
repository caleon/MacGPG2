  
  def patches
    { :p0 => DATA }
  end
  
    xconfig = "homebrew.xconfig"
      xconfig = "homebrew-ppc.xconfig"
      build_env = ARGV.build_env.gsub ' ', '\\\ '
      inreplace 'homebrew-ppc.xconfig' do |s|
         s.gsub! '#SDKROOT#', "#{build_env}/SDKs/MacOSX10.5.sdk"
    # Use the homebrew.xconfig file to force using GGC_VERSION specified.
    inreplace 'Makefile' do |s|
      s.gsub! /@xcodebuild/, "@xcodebuild -xcconfig #{xconfig}"
    end
    

__END__

diff --git homebrew.xconfig homebrew.xconfig
new file mode 100644
index 0000000..fdb4290
--- /dev/null
+++ homebrew.xconfig
@@ -0,0 +1 @@
+GCC_VERSION = com.apple.compilers.llvmgcc42

diff --git homebrew-ppc.xconfig homebrew-ppc.xconfig
new file mode 100644
index 0000000..9515ac6
--- /dev/null
+++ homebrew-ppc.xconfig
@@ -0,0 +1,2 @@
+GCC_VERSION = com.apple.compilers.llvmgcc42
+SDKROOT = #SDKROOT#