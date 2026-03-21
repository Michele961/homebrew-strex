class StrexCli < Formula
  desc "CLI-first API collection runner"
  homepage "https://github.com/Michele961/strex"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Michele961/strex/releases/download/v0.2.0/strex-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4faadf0050a490ada4de7acd6a0f20ff816597d298ac6a4d6b693982b3ddfcf4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Michele961/strex/releases/download/v0.2.0/strex-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c984c4705d96efdaaff19c8dbeeda7ed2da2f037d852d3a8b7c9a0b8d6da8dab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Michele961/strex/releases/download/v0.2.0/strex-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4dd2141ccb24233e20223960e8772d0af3df1cec24742766d2cacf631cd0fa26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Michele961/strex/releases/download/v0.2.0/strex-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6513bf672ba254bbc7e369b669d294db3084becf4b2c24f307973bd8d44dbaab"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "strex" if OS.mac? && Hardware::CPU.arm?
    bin.install "strex" if OS.mac? && Hardware::CPU.intel?
    bin.install "strex" if OS.linux? && Hardware::CPU.arm?
    bin.install "strex" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
