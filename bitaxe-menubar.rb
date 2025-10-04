class BitaxeMenubar < Formula
  desc "BitAxe MenuBar - Simple Bitaxe miner status bar app"
  homepage "https://github.com/jeppepeppe1/BitAxe-MenuBar"
  url "https://github.com/jeppepeppe1/BitAxe-MenuBar/archive/refs/heads/main.zip"
  version "1.0.1"
  sha256 "e168c1eaccd0a79b4e6cfa4337780bf9a3d2ef8f6e5ac231fcb483c342bfa0d9"

  depends_on "swift" => :build
  depends_on "terminal-notifier"

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"
    bin.install ".build/release/bitaxe-menubar"
    
    # Install resources
    resources_dir = prefix/"Resources"
    resources_dir.mkpath
    resources_dir.install "Sources/BitAxeMenuBar/Resources/bitaxe-logo-square.png"
    resources_dir.install "Sources/BitAxeMenuBar/Resources/bitaxe-logo.png"
    
    # Create configuration script
    (bin/"bitaxe-config").write <<~EOS
      #!/bin/bash
      if [ -z "$1" ]; then
        echo "Usage: bitaxe-config <IP_ADDRESS>"
        echo "Example: bitaxe-config 192.168.1.100"
        echo ""
        echo "Current IP: $(defaults read com.bitaxe.menubar BitAxeIP 2>/dev/null || echo 'Not configured')"
        exit 1
      fi
      
      # Set the IP address in UserDefaults
      defaults write com.bitaxe.menubar BitAxeIP "$1"
      echo "BitAxe IP address set to: $1"
      echo "Restart bitaxe-menubar to apply changes."
    EOS
    chmod 0755, bin/"bitaxe-config"
  end

  def caveats
    <<~EOS
      BitAxe MenuBar has been installed!
      
      To run BitAxe MenuBar:
        bitaxe-menubar &
        
      Note: The & runs it in background so you can close the terminal.
      
      To configure your BitAxe IP address via CLI:
        bitaxe-config 192.168.1.100
      
      To run on startup, add to Login Items in System Preferences:
        1. Open System Preferences > Users & Groups
        2. Select your user > Login Items
        3. Click + and add bitaxe-menubar
      
      The app requires configuration before use. Configure your BitAxe IP address:
        bitaxe-config 192.168.1.100
    EOS
  end

  test do
    # Test that the binary exists and is executable
    assert_predicate bin/"bitaxe-menubar", :exist?
    assert_predicate bin/"bitaxe-menubar", :executable?
  end
end
