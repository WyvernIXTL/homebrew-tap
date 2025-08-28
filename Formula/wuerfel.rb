class Wuerfel < Formula
  desc "Diceware password generator cli based on eff password lists."
  homepage "https://github.com/WyvernIXTL/wuerfel-rs"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/WyvernIXTL/wuerfel-rs/releases/download/v0.1.10/wuerfel-aarch64-apple-darwin.tar.xz"
      sha256 "87d7322114d13cf91673a345cb6d232f80483f5f0a7af83f4be2a73999fb1dbc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WyvernIXTL/wuerfel-rs/releases/download/v0.1.10/wuerfel-x86_64-apple-darwin.tar.xz"
      sha256 "6a4ef002a60bd3b6b2bbbe26fb9e1d9825cf93ea4a58bc51dfb4e5980769b6ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/WyvernIXTL/wuerfel-rs/releases/download/v0.1.10/wuerfel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7cdadeaebda1476f299a8c866501d7d6debda513b9ce3a9418594e43d529b408"
    end
    if Hardware::CPU.intel?
      url "https://github.com/WyvernIXTL/wuerfel-rs/releases/download/v0.1.10/wuerfel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ce2f6b77da82fc5f50f697e8fac69e4b6908f278191c76b338a06248a2620a89"
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
