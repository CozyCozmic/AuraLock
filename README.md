# AuraLock: Zero-Touch Biometric Lock & Wake for Linux

A fully automated, zero-touch biometric locking and waking system designed for modern Linux laptops (tested on Arch/CachyOS with Intel Meteor Lake processors and KDE Plasma 6 Wayland).

It combines **Intel ISH / YuNet CNN face detection**, **DPMS display power management**, **`swayidle`**, and **`ydotool`** input injection to deliver a seamless, hands-free experience akin to Windows Hello or Apple Face ID.

---

## Features
- **Hands-Free Walk-Away Locking:** Automatically detects when you step away using OpenCV YuNet face detection, locking your session and turning off display backlights (`DPMS`).
- **Camera-Based Wake-on-Approach:** Intelligently polls the camera at low frequency while locked to detect your return, waking the display and input layers automatically.
- **Biometric Sign-In Integration:** Works seamlessly with `linuxcampam` (IR + RGB) and patched QML login sheets to auto-dismiss credentials instantly.
- **Zero Idle CPU Footprint:** Leverages `swayidle` for event-driven idle tracking while unlocked.

---

## Requirements
- **Desktop Environment:** KDE Plasma 6 (Wayland)
- **Dependencies:** Python 3, OpenCV (`python-opencv`), `swayidle`, `ydotool`, `qdbus6`, `kscreen-doctor`
- **Hardware:** RGB/IR Camera (Intel ISH / VSC supported)

---

## Installation

1. Clone this repository:
   ```bash
   git clone [https://github.com/NotCozmic/linux-zero-touch-lock.git](https://github.com/NotCozmic/linux-zero-touch-lock.git)
   cd linux-zero-touch-lock
   ```

2. Run the automated installer:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. Ensure your user is part of the `input` group for `ydotool` virtual input injection:
   ```bash
   sudo usermod -aG input $USER
   ```
   *(Log out and log back in for group changes to take effect).*

---

## Planned Future Roadmap
- **Exponential Back-Off Polling:** Scale down camera check frequency over time (e.g., from every 1.5s to every 60s after 10 minutes) to preserve laptop battery when away for extended periods.
- **Hardware Sensor Fallback & Auto-Detection:** Automatically detect and bind to Intel ISH Human Presence Sensors (HPD) as Tier 1, falling back to the YuNet camera poller for unsupported hardware.
- **Configuration GUI & Toggles:** A native settings panel (PyQt/Kirigami) to adjust idle timeouts, toggle features, and manage polling intervals via a `config.json` file.
- **Visual Sign-In Animation:** Implement a custom on-screen graphical overlay (resembling a Windows Hello or Face ID scanning ring) during biometric authentication.
- **Universal Linux Packaging:** Bundle the system into a standalone app/package deployable across major Linux distros.

---

## AI Collaboration Statement
This project was conceptualized and architected in collaboration with **Gemini Argon** for process drafting, alongside **Gemini 3.5 Flash** and **Flash Light** for testing, debugging, and building the tool.
