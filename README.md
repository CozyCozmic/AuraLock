# AuraLock - Windows Hello for Linux.

Howdy was too large for my taste and it was missing out on the features I wanted for my laptop, specifically the ability to walk away from my laptop, for it to auto turn off, then come back and it automatically recognizes me and it signs back in. It was one of the features I used on Windows that prevented me from originally switching to Linux in the first place, but now it is made and working! 

So far the System has only been tested on CachyOS with my Ideapad Pro5i which uses an Intel Meteor Lake processor as well as KDE Plasma 6 Wayland.

The system combines **Intel ISH / YuNet CNN face detection**, **DPMS display power management**, **`swayidle`**, and **`ydotool`** input injection to recreate the seamless Windows Hello experience. 

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

*Note: I plan to add more device and hardware support over time*

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

## Security Statement
- This program is suspectible to Frame Interception / Spoofing: The Camera Poller processes raw RGB/IR frames via the OpenCV, but as a result physical printouts or high-def photos held up to the camera could theoretically trigger false positives if proper liveness detection isn't enforced. By default when configured with LinuxCamPAM this system will not login a User unless both the IR and RGB camera sensors agree the person is the User, but nonetheless this is an issue.
- Session State Hijacking: AuraLock relies on standard qdbus6 and loginctl signls to lock and unlock. A malicious script could gain access to your user bus and simulate user activity. However because the system does run inside your isolated user-space session context, standard Linux user permission boundaries protect AuraLock from cross-user attacks.

TLDR: DO NOT use AuraLock as your only login system on your computer & please use it at your own risk. 

---

## AI Statement
I want to be completely honest with how this project was conceived and the tools I used. Howdy and authFace did not have the specific Wake-on-approach & Hands-Free Walk-Away Locking which I enjoyed on my Windows Laptop before migrating to Linux. At the time of making this project, I did not have the understanding, nor the knowledge on how to build this myself based on the little amount of resources I found at the time. 

I used Gemini 4.0 Argon to conceptualize and gather information on my system. It helped me find all the drivers, hubs, and sensors I couldn't find myself. Then I used Gemini 3.5 Flash and Gemini 3.5 Flash lite to build out the alpha version of this program. As I continue working on this project over time I will update this section with how every portion of this project was created and how much AI was used in the process.
