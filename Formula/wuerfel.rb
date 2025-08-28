class Wuerfel < Formula
  desc "Diceware password generator cli based on eff password lists."
  homepage "https://github.com/WyvernIXTL/wuerfel-rs"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/WyvernIXTL/wuerfel-rs/releases/download/v0.1.11/wuerfel-aarch64-apple-darwin.tar.xz"
      sha256 "72d843f7918da871277a81f1d23b6a6e9bcc08b040691ece589c7e6db45baa40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WyvernIXTL/wuerfel-rs/releases/download/v0.1.11/wuerfel-x86_64-apple-darwin.tar.xz"
      sha256 "6361445b7070b64b008c6ee7e3991dee6f1fd694847bfdf107000899f5cd7314"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/WyvernIXTL/wuerfel-rs/releases/download/v0.1.11/wuerfel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eec6cf92a5f23fafc1abc63990719e086bd04adf5dd3e4df9b5b0b6bf480d340"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WyvernIXTL/wuerfel-rs/releases/download/v0.1.11/wuerfel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c1e6bf7f10c554d2d845add87b68a32235c056e981a20c9dd1e0ebd7d0d63adb"
    end
  end
  license "MPL-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wuerfel" if OS.mac? && Hardware::CPU.arm?
    bin.install "wuerfel" if OS.mac? && Hardware::CPU.intel?
    bin.install "wuerfel" if OS.linux? && Hardware::CPU.arm?
    bin.install "wuerfel" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
