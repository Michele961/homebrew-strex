class StrexCli < Formula
  desc "CLI-first API collection runner"
  homepage "https://github.com/Michele961/strex"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Michele961/strex/releases/download/v0.1.0/strex-cli-aarch64-apple-darwin.tar.xz"
      sha256 "5f09420e800857e9a7a1626b427247fe8aef42739f02231a217449612bfa87bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Michele961/strex/releases/download/v0.1.0/strex-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8b1f2ea238c7c8495eb0125331f535c5c3fffc24d63aea44334275e71b663f0f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/Michele961/strex/releases/download/v0.1.0/strex-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c28e8f36d52b35b7df1764aa42151b6434466971429e31e645624f074d974e6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Michele961/strex/releases/download/v0.1.0/strex-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d115b9227fde0baa60792079ba36d1d65b73d749c59493a7a5b8443b98c1ad27"
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
