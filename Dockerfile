# Railway KasmVNC High-Survival Browser
# Lightweight KasmVNC desktop optimized for heavy websites on weak Railway resources.
FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine317

USER root

# Chromium is used as the default browser because Facebook/YouTube usually behave
# better in Chromium than Firefox in tiny container desktops.
# Keep packages minimal: desktop, browser, file manager, panel, terminal.
RUN apk add --no-cache \
    chromium \
    pcmanfm \
    tint2 \
    adwaita-icon-theme \
    hicolor-icon-theme \
    ttf-dejavu \
    ttf-liberation \
    dbus-x11 \
    xterm \
    nano \
    curl \
    ca-certificates \
  && rm -rf /tmp/* /var/cache/apk/*

COPY root/ /

RUN chmod +x /defaults/autostart /usr/local/bin/railway-start /usr/local/bin/cloud-browser /usr/local/bin/browser-reset

# Safe defaults. Railway Variables can override these.
ENV CUSTOM_USER=admin \
    PASSWORD=123456 \
    TITLE="Railway KasmVNC Smooth Browser" \
    FM_HOME=/config \
    START_DOCKER=false \
    TZ=Etc/UTC \
    PUID=1000 \
    PGID=1000 \
    UMASK=022 \
    SMOOTH_MODE=true \
    START_BROWSER=true \
    BROWSER_HOME=https://www.google.com \
    WALLPAPER_FILE=/defaults/assets/wallpaper.png \
    BROWSER_WINDOW_SIZE=1000,560 \
    BROWSER_SCALE=0.85 \
    BROWSER_RENDERERS=2 \
    BROWSER_CACHE_MB=64 \
    NO_AT_BRIDGE=1 \
    GDK_BACKEND=x11 \
    LIBGL_ALWAYS_SOFTWARE=1 \
    CHROME_DEVEL_SANDBOX=/usr/lib/chromium/chrome-sandbox

# Railway injects PORT. railway-start maps PORT -> CUSTOM_PORT.
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/railway-start"]
