class Idris2 < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris2/archive/v0.2.1.tar.gz"
  sha256 "7be16253c9592802f0ab1ebb1b635bd3e254577205e1fd7d8139b1683732fcc7"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris2.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3dd1bbee7fae182553f34b89bf5c3049a8b8bfcd4206c7c7b904ad6b0672259b" => :catalina
    sha256 "48268ef2985009712a46469b3ec7f849ba91f640d17e8f0b86b24f9e0477c267" => :mojave
    sha256 "4f0a8f3c3ef289309fe2b02ff6f5b395e3b71fee94de1dbc0b9a70589788b1bd" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "chezscheme"

  def install
    ENV.deparallelize
    scheme = Formula["chezscheme"].bin/"chez"
    system "make", "bootstrap", "SCHEME=#{scheme}", "PREFIX=#{libexec}"
    system "make", "install", "PREFIX=#{libexec}"
    # idris2.so is an executable file generated by Idris2
    bin.install "#{libexec}/bin/idris2_app/idris2.so" => "idris2"
    lib.install_symlink Dir["#{libexec}/lib/*.dylib"]
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris2", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!",
                 shell_output("./build/exec/hello_app/hello.so").chomp
  end
end
