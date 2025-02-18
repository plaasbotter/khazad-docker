# Base image with Wine and SteamCMD
FROM debian:bookworm-slim

# Set environment variables
ENV STEAM_APP_ID=3349480 \
    STEAM_USERNAME=anonymous \
    WINEARCH=win64 \
    WINEPREFIX=/home/steam/game/.wine \
    PATH="/usr/lib/wine:${PATH}" \
    DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        ca-certificates \
        lib32gcc-s1 \
        wine64 \
        wine32 \
        wine32-preloader \
        winbind \
        cabextract \
        unzip \
        gosu \
        psmisc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create steam user (non-root)
RUN useradd -m steam && \
    mkdir -p /home/steam/steamcmd && \
    chown -R steam:steam /home/steam

USER steam
WORKDIR /home/steam

# Download and install SteamCMD
RUN mkdir -p /home/steam/steamcmd && \
    cd /home/steam/steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Copy the start script
COPY --chown=steam:steam start.sh /home/steam/start.sh
RUN chmod +x /home/steam/start.sh

EXPOSE 7777/udp 7777/tcp

# Start the server with wine
CMD ["/home/steam/start.sh"]
