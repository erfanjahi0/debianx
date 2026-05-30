# Railway KasmVNC Smooth Cloud Browser
# Lightweight browser desktop: KasmVNC + Openbox + Firefox + PCManFM.
FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine317

USER root

# Keep the package list small for speed and lower memory use.
RUN apk add --no-cache \
    firefox \
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

RUN chmod +x /defaults/autostart /usr/local/bin/railway-start

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
    START_FIREFOX=true \
    WALLPAPER_FILE=/defaults/assets/wallpaper.png \
    MOZ_DISABLE_GPU=1 \
    MOZ_WEBRENDER=0 \
    GDK_BACKEND=x11 \
    LIBGL_ALWAYS_SOFTWARE=1

# Railway injects PORT. railway-start maps PORT -> CUSTOM_PORT.
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/railway-start"]
