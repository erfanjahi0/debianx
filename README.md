# Railway KasmVNC Smooth Browser - Heavy Browsing Build

A lightweight browser desktop for Railway using **KasmVNC + Openbox + Chromium + PCManFM**.

This version focuses on one thing: **make browsing survive better on weak Railway resources**. It is optimized for smoothness and stability over image quality.

## What changed in this build

- Uses **Chromium** instead of Firefox for better Facebook/YouTube compatibility.
- Adds a special `cloud-browser` launcher with low-resource Chromium flags.
- Limits Chromium renderer processes by default.
- Disables GPU/compositor features that often crash in container desktops.
- Uses small browser cache values to reduce memory pressure.
- Cleans stale browser/session locks on Railway restart.
- Keeps v2 fixes: right-click app menu, desktop shortcuts, PCManFM file manager, Downloads shortcut, terminal shortcut.
- Keeps optional wallpaper support using only `root/defaults/assets/wallpaper.png`.
- README now documents heavy browsing settings and safe usage.

## Important honesty

This build gives the **best chance** for smoother browsing on Railway, but it cannot turn Railway into a powerful VPS. Facebook and YouTube are heavy. If Railway gives low CPU/RAM at that moment, those sites can still lag or crash.

For maximum stability:

- Use one KasmVNC browser tab only.
- Use one to three Chromium tabs inside the desktop.
- Use lower video quality on YouTube: 144p, 240p, or 360p.
- Avoid opening multiple video/social sites together.
- Avoid huge wallpapers.

## Deploy on Railway

1. Upload this project to GitHub.
2. Create a Railway project from the GitHub repo.
3. Let Railway build from the `Dockerfile`.
4. Open the latest Deploy Logs.
5. Find this line:

```text
Web port : 8080
```

6. Go to **Settings → Public Networking**.
7. Generate the public domain using the port shown in logs, usually:

```text
8080
```

## Default login

```text
Username: admin
Password: 123456
```

## Recommended Railway Variables for heavy browsing

Set these in **Railway → Service → Variables**:

```env
CUSTOM_USER=admin
PASSWORD=123456
START_BROWSER=true
SMOOTH_MODE=true
BROWSER_RENDERERS=2
BROWSER_SCALE=0.80
BROWSER_WINDOW_SIZE=960,540
BROWSER_CACHE_MB=64
BROWSER_MEDIA_CACHE_MB=32
BROWSER_HOME=https://www.google.com
```

After changing variables, redeploy or restart the service.

## Environment variables explained

### Login

```env
CUSTOM_USER=admin
PASSWORD=123456
```

Controls the KasmVNC login username and password.

### Browser startup

```env
START_BROWSER=true
```

- `true` = automatically open Chromium when the desktop starts.
- `false` = desktop starts without browser, useful if you want lower startup memory.

### Browser homepage

```env
BROWSER_HOME=https://www.google.com
```

The page Chromium opens at startup. For maximum stability, keep it lightweight. Do not set YouTube or Facebook as the startup page.

### Browser renderer limit

```env
BROWSER_RENDERERS=2
```

Controls how many renderer processes Chromium can use.

Recommended:

```text
1 = lowest memory, can feel slower
2 = best balance
3 = smoother with enough RAM, more crash risk
```

### Browser scale

```env
BROWSER_SCALE=0.80
```

Makes the browser render smaller internally. This reduces workload and can help smoothness.

Recommended values:

```text
0.75 = fastest, text smaller
0.80 = best smoothness
0.85 = balanced
1.00 = normal quality, slower
```

### Browser window size

```env
BROWSER_WINDOW_SIZE=960,540
```

Lower window size means less work for the remote desktop and browser.

Recommended:

```text
854,480  = fastest
960,540  = good for YouTube/Facebook
1024,600 = balanced
1280,720 = better quality, more lag
```

### Browser cache

```env
BROWSER_CACHE_MB=64
BROWSER_MEDIA_CACHE_MB=32
```

Keeps cache small so Chromium does not eat too much disk/memory.

Recommended:

```text
32/16 = lowest memory
64/32 = balanced
128/64 = better for repeated browsing, heavier
```

### Railway/KasmVNC port

```env
CUSTOM_PORT=8080
```

Usually you do not need to set this. Railway injects `PORT`, and the startup script maps it automatically.

Always use the port shown in deploy logs for Railway Public Networking.

## Optional wallpaper

Wallpaper is optional and stays exactly PNG-only.

To set wallpaper, add this file in GitHub:

```text
root/defaults/assets/wallpaper.png
```

Then commit, push, and redeploy Railway.

### Wallpaper requirements

Recommended:

```text
Format: PNG
Name: wallpaper.png
Path: root/defaults/assets/wallpaper.png
Size: 1280x720 or 1024x600
File size: under 500 KB if possible
```

For maximum browsing smoothness:

```text
Use no wallpaper, or use a small/simple wallpaper.
Avoid 4K wallpapers.
Avoid huge PNG files.
Avoid animated/background effects.
```

If `wallpaper.png` is missing, the desktop uses the default lightweight background.

## How to use the desktop

### Open browser

Double-click **Browser** on the desktop, or right-click the desktop:

```text
Applications → Chromium Browser
```

### Open file manager

Double-click **File Manager**, or right-click the desktop:

```text
Applications → File Manager
```

Downloads are saved in:

```text
/config/Downloads
```

### Reset browser if it keeps crashing

Right-click desktop:

```text
Applications → Reset Browser Cache
```

This removes stale cache/lock files and helps when Chromium gets stuck after a Railway restart.

## YouTube/Facebook smoothness tips

For YouTube:

```text
Use 144p, 240p, or 360p.
Do not use HD.
Do not use fullscreen if it starts lagging.
Close other tabs before video playback.
```

For Facebook:

```text
Use mobile Facebook if desktop Facebook is too heavy.
Try: https://m.facebook.com
Avoid opening many reels/videos together.
```

For general browsing:

```text
Keep only 1 to 3 tabs open.
Close the browser fully before long sessions.
Restart Railway if memory gets exhausted.
Use Browser Reset if Chromium gets corrupted.
```

## About the noVNC/KasmVNC error popup

KasmVNC uses a web client, and the error page may still mention noVNC internally. This build reduces the chance by:

- Cleaning stale X/VNC/browser locks on start.
- Starting only one browser window.
- Using a lighter Chromium setup.
- Avoiding heavy desktop environments.

Still, no browser-based remote desktop can honestly guarantee the popup will never happen. It can appear if:

```text
Railway restarts or sleeps the container
Network drops
Multiple KasmVNC tabs are open
Browser or desktop runs out of memory
The web client glitches
```

If it appears, refresh the Railway URL. If it repeats, restart the Railway service.

## Future improvement documentation

Possible future improvements:

1. Add a Railway Volume mounted to `/config` for persistent browser profile/downloads.
2. Add a mobile-first browser launcher that opens `m.facebook.com` by default.
3. Add separate profiles: `Normal`, `YouTube Low`, `Facebook Low`.
4. Add a simple landing page before desktop with buttons for Browser, File Manager, and Reset.
5. Add a healthcheck page so Railway can detect startup better.

## Best realistic expectation

This build is for:

```text
Light browsing: good
Facebook: usable if tabs are controlled
YouTube: usable at low quality if Railway resources are enough
Heavy multitasking: not recommended
HD streaming: not recommended
```

Smoothness is prioritized over visual quality.
