#!/usr/bin/env bash
set -e

echo "=== Installing AuraLock (Zero-Touch Biometric System) ==="

# 1. Check for LinuxCamPAM dependency (optional warning)
echo "[+] Checking for authentication dependencies..."
if systemctl list-unit-files | grep -q "linuxcampam" || command -v linuxcampam &> /dev/null; then
    echo "[✓] LinuxCamPAM detected on system."
else
    echo "[!] Warning: LinuxCamPAM was not detected. AuraLock will handle wake/lock, but biometric face login requires LinuxCampam."
fi

# 2. Create local bin and systemd user directories
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

# 3. Copy scripts
echo "[+] Copying helper scripts to ~/.local/bin/ ..."
cp bin/check-presence.py ~/.local/bin/
cp bin/walkaway-handler.sh ~/.local/bin/
cp bin/wake-watcher.py ~/.local/bin/

chmod +x ~/.local/bin/check-presence.py
chmod +x ~/.local/bin/walkaway-handler.sh
chmod +x ~/.local/bin/wake-watcher.py

# 4. Copy systemd service files
echo "[+] Installing systemd user services..."
cp systemd/walkaway-idle.service ~/.config/systemd/user/
cp systemd/wake-watcher.service ~/.config/systemd/user/

# 5. Reload and enable services
echo "[+] Enabling and starting services..."
systemctl --user daemon-reload
systemctl --user enable --now walkaway-idle.service
systemctl --user enable --now wake-watcher.service

echo "=== Installation Complete! ==="
echo "Services are now active and running. Ensure you belong to the input group for ydotool:"
echo "  sudo usermod -aG input \$USER"
