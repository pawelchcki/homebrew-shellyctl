class Shellyctl < Formula
  desc "Command-line client for Shelly smart devices, built on shelly-rpc."
  homepage "https://github.com/pawelchcki/shelly-rpc"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/pawelchcki/shelly-rpc/releases/download/v0.1.0/shellyctl-aarch64-apple-darwin.tar.xz"
      sha256 "023099139084484e506b455b3fb04fc4c7895d1e1917acae0d9bd297fe4f6da4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pawelchcki/shelly-rpc/releases/download/v0.1.0/shellyctl-x86_64-apple-darwin.tar.xz"
      sha256 "f69c1c4dc8191d7cbe590fc53000d09d82496e490cebc4968d7241617d225a88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pawelchcki/shelly-rpc/releases/download/v0.1.0/shellyctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e23cde49c76e2a976307f91d050230d90f67cfe01235355a357b1b4b051c9d40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pawelchcki/shelly-rpc/releases/download/v0.1.0/shellyctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "55b470a9ba8b67d194f856879ae952d930fe53e246f92adbf6ba25b2c54cfe24"
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
