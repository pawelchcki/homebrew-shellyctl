class Shellyctl < Formula
  desc "Command-line client for Shelly smart devices, built on shelly-rpc."
  homepage "https://github.com/pawelchcki/shelly-rpc"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pawelchcki/shelly-rpc/releases/download/v0.1.0/shellyctl-aarch64-apple-darwin.tar.xz"
      sha256 "79eb4ef2bfb683e55a548b0d364fdf5178e1ef7931eec9f91449efd4a107ae36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pawelchcki/shelly-rpc/releases/download/v0.1.0/shellyctl-x86_64-apple-darwin.tar.xz"
      sha256 "20db185f0fb2f1ce1dc5842f7fc1f45b7d3ecfac8790edd26e1881e1ee4ba0e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pawelchcki/shelly-rpc/releases/download/v0.1.0/shellyctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f649653e1b3adaa95eb66f8ee2cf06c7122d6d89b669c255a55cdd65a03350e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pawelchcki/shelly-rpc/releases/download/v0.1.0/shellyctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "41be6387f32ad7dbce5d1b9e0608de07b0c26d5cf371ea65f4f51c7f726a5067"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "shellyctl" if OS.mac? && Hardware::CPU.arm?
    bin.install "shellyctl" if OS.mac? && Hardware::CPU.intel?
    bin.install "shellyctl" if OS.linux? && Hardware::CPU.arm?
    bin.install "shellyctl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
