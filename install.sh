#!/usr/bin/env bash
set -e

echo "=== Installing AuraLock (Zero-Touch Biometric System) ==="

# 1. Create local bin and systemd user directories
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

# 2. Copy scripts
echo "[+] Copying helper scripts to ~/.local/bin/ ..."
cp bin/check-presence.py ~/.local/bin/
cp bin/walkaway-handler.sh ~/.local/bin/
cp bin/wake-watcher.py ~/.local/bin/

chmod +x ~/.local/bin/check-presence.py
chmod +x ~/.local/bin/walkaway-handler.sh
chmod +x ~/.local/bin/wake-watcher.py

# 3. Copy systemd service files
echo "[+] Installing systemd user services..."
cp systemd/walkaway-idle.service ~/.config/systemd/user/
cp systemd/wake-watcher.service ~/.config/systemd/user/

# 4. Reload and enable services
echo "[+] Enabling and starting services..."
systemctl --user daemon-reload
systemctl --user enable --now walkaway-idle.service
systemctl --user enable --now wake-watcher.service

echo "=== Installation Complete! ==="
echo "Services are now active and running. Ensure you belong to the input group for ydotool:"
echo "  sudo usermod -aG input \$USER"
