# Railway KasmVNC Smooth Cloud Browser

A lightweight browser-based Linux desktop designed for Railway. It uses KasmVNC/Webtop, Openbox, Firefox, PCManFM, and a very small panel. The goal is smoothness over HD quality.

This project is meant for light browsing, file work, and simple web tasks. It is not meant to behave like a powerful full VPS desktop.

---

## What is included

- KasmVNC web desktop
- Openbox lightweight window manager
- Firefox with low-overhead settings
- PCManFM file manager
- Downloads folder shortcut
- Terminal shortcut
- Right-click desktop app menu
- Optional GitHub-controlled wallpaper
- Railway-ready Docker setup

---

## Default login

```txt
Username: admin
Password: 123456
```

You can change these using Railway Variables:

```env
CUSTOM_USER=admin
PASSWORD=123456
```

---

## Railway deploy

1. Upload this project to a GitHub repository.
2. Open Railway.
3. Create a new project from your GitHub repo.
4. Railway will build from the `Dockerfile`.
5. After deploy, open the Deploy Logs.
6. Find the line that says:

```txt
Web port : 8080
```

7. Go to Railway → Service → Settings → Public Networking.
8. Generate a domain using that exact port.

Usually the correct port is:

```txt
8080
```

If the log shows another port, use the port shown in the log.

---

## Railway Variables / ENV settings

These variables are optional. The project already has safe defaults. You only need to add variables in Railway if you want to change the login, startup behavior, or smoothness settings.

### Recommended smooth setup

For the smoothest Railway experience, use these variables:

```env
CUSTOM_USER=admin
PASSWORD=123456
START_FIREFOX=true
SMOOTH_MODE=true
VNC_RESOLUTION=1024x600
VNC_DEPTH=16
MAX_FPS=15
```

For slightly better quality, try this after confirming it runs smoothly:

```env
VNC_RESOLUTION=1280x720
MAX_FPS=20
```

If it starts lagging, return to `1024x600` and `15 FPS`.

### What each variable does

| Variable | Default | What it does | Recommended value |
|---|---:|---|---|
| `CUSTOM_USER` | `admin` | Login username for the KasmVNC web desktop. | `admin` |
| `PASSWORD` | `123456` | Login password for the KasmVNC web desktop. Use at least 6 characters. | Change it if your URL is public. |
| `TITLE` | `Railway KasmVNC Smooth Browser` | Browser page title shown by the KasmVNC web UI. | Any name you like. |
| `PORT` | Set by Railway | Railway may inject this automatically. The startup script reads it. | Usually leave unset. |
| `CUSTOM_PORT` | Uses `PORT`, fallback `8080` | Web port used by KasmVNC inside the container. Your Railway public networking port must match the deploy log. | `8080` if Railway log says 8080. |
| `PUID` | `1000` | Linux user ID used by the container. Helps with file permissions in `/config`. | Leave default. |
| `PGID` | `1000` | Linux group ID used by the container. Helps with file permissions in `/config`. | Leave default. |
| `START_FIREFOX` | `true` | Opens Firefox automatically when the desktop starts. | `true` |
| `SMOOTH_MODE` | `true` | Enables low-overhead Firefox and desktop settings. | `true` |
| `VNC_RESOLUTION` | Base image default unless set | Controls desktop resolution. Lower resolution is smoother. | `1024x600` |
| `VNC_DEPTH` | Base image default unless set | Controls color depth. Lower depth uses less bandwidth/CPU. | `16` |
| `MAX_FPS` | Base image default unless set | Controls max frame rate. Lower FPS is less sharp but smoother on weak servers. | `15` |
| `WALLPAPER_FILE` | `/defaults/assets/wallpaper.png` | Path checked for optional custom wallpaper. | Leave default. |
| `MOZ_DISABLE_GPU` | `1` | Disables Firefox GPU acceleration to reduce glitches in containers. | `1` |
| `MOZ_WEBRENDER` | `0` | Disables Firefox WebRender for lower overhead. | `0` |
| `LIBGL_ALWAYS_SOFTWARE` | `1` | Forces software rendering instead of unstable container GPU rendering. | `1` |

### Port rule

Railway may provide `PORT` automatically. The deploy log prints the real web port, for example:

```txt
Web port : 8080
```

Use that exact number in Railway:

```txt
Railway → Service → Settings → Public Networking → Generate Domain → Port 8080
```

Do not guess the port. Always trust the deploy log.

---

## How to use the desktop

### Open the file manager

Right-click on the empty desktop area:

```txt
Applications → File Manager
```

Or double-click the desktop shortcut:

```txt
File Manager
```

### Downloads folder

Firefox downloads go here:

```txt
/config/Downloads
```

Open it from:

```txt
Applications → Downloads
```

or the desktop `Downloads` shortcut.

### Terminal

Right-click desktop:

```txt
Applications → Terminal
```

---

## Optional wallpaper system

This version does **not** force a custom wallpaper by default.

If you do nothing, the desktop uses the normal lightweight default background.

To use your own wallpaper, add this file in GitHub:

```txt
root/defaults/assets/wallpaper.png
```

Then commit, push, and redeploy Railway.

### Wallpaper rules

Use this exact filename:

```txt
wallpaper.png
```

Use this exact path:

```txt
root/defaults/assets/wallpaper.png
```

Recommended size:

```txt
1280x720
```

Also okay:

```txt
1024x600
1366x768
1920x1080
```

Best format:

```txt
PNG or JPG
```

Recommended file size:

```txt
Under 500 KB is best
Under 1 MB is okay
Avoid huge 4K images
```

For the smoothest Railway performance, use a simple compressed image. Avoid animated wallpapers, very high-resolution images, or large transparent PNG files.

### How it works

At startup, the script checks:

```txt
/defaults/assets/wallpaper.png
```

If that file exists, it copies it to:

```txt
/config/.railway-wallpaper.png
```

and applies it to the desktop.

If that file does not exist, it uses the default plain background.

The desktop wallpaper configuration is written during startup. If you change the wallpaper from inside the desktop GUI, that change is not the intended permanent method. The clean method is to change the GitHub file and redeploy.

---

## Smoothness mode

The project is tuned for smoothness instead of HD quality.

The Firefox profile disables or reduces:

- GPU/WebRender usage
- browser animations
- predictive networking
- unnecessary telemetry
- crash session restore overhead
- heavy visual transitions

This helps on Railway because shared CPU/RAM can be limited.

### For smoother browsing

Use fewer tabs. Avoid video-heavy pages. Keep the resolution low. Prefer mobile or lightweight versions of websites when possible.

Recommended display target:

```txt
1024x600 or 1280x720
Smoothness > quality
```

---

## About the noVNC error popup

KasmVNC uses a browser client internally, and some internal messages may still say `noVNC`. That does not mean this is the old plain noVNC setup.

This version reduces the chance of that popup by:

- fixing desktop permission setup
- avoiding broken startup scripts
- avoiding duplicate desktop sessions
- keeping the desktop lighter

A browser-based VNC session can still show a temporary client error if the Railway container restarts, the phone browser kills the tab, or the network connection drops. If it happens, refresh the Railway URL.

---

## Persistent storage

Without a Railway Volume, files may disappear after redeploy/restart.

For persistence, attach a Railway Volume to:

```txt
/config
```

That keeps:

```txt
/config/Downloads
/config/Documents
Firefox profile data
Desktop files
```

---

## Project structure

```txt
Dockerfile
railway.json
.dockerignore
README.md
root/defaults/autostart
root/defaults/assets/.gitkeep
root/defaults/assets/wallpaper.png   optional, not included by default
root/usr/local/bin/railway-start
```

---

## Future improvement documentation

Possible future upgrades:

### 1. Add resolution control

Add variables such as:

```env
VNC_RESOLUTION=1024x600
VNC_DEPTH=16
```

Only add this if the base image supports those variables correctly.

### 2. Add a lightweight browser alternative

Firefox is included because it is available and reliable. A future version could test a lighter browser if the package is stable in the base image.

### 3. Add optional volume setup guide

A future README section can include screenshots for Railway Volume mounting to `/config`.

### 4. Add custom homepage

Firefox homepage can be controlled through the generated `user.js` file inside:

```txt
/config/.mozilla/firefox/railway-profile/user.js
```

### 5. Add optional app shortcuts

More desktop shortcuts can be created in:

```txt
root/defaults/autostart
```

Keep apps minimal. More apps means slower Railway performance.

---

## Troubleshooting

### 502 Bad Gateway

Check Deploy Logs. If it says:

```txt
Web port : 8080
```

then Railway Public Networking must use port:

```txt
8080
```

### File manager not visible

Right-click desktop:

```txt
Applications → File Manager
```

or open terminal and run:

```bash
pcmanfm /config &
```

### Desktop feels slow

Close extra tabs. Avoid heavy pages. Restart Firefox from the right-click menu:

```txt
Applications → Close Firefox
```

Then open Firefox again.

### Wallpaper not showing

Check all of these:

```txt
Path: root/defaults/assets/wallpaper.png
Filename: wallpaper.png
File type: PNG or JPG
Redeploy done after pushing
```

If the file is missing, the default background is used.

---

## Best use case

This is best used as:

```txt
A lightweight cloud browser + file manager
```

Not as:

```txt
A full Windows-like cloud PC
A gaming desktop
A video streaming machine
A heavy multitasking VPS
```
