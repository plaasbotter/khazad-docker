#!/bin/bash

echo "Starting the running script"

# Variables
STEAMCMD_DIR="/home/steam/steamcmd"
GAME_DIR="/home/steam/game"
APP_ID=${STEAM_APP_ID:-3349480}


echo "Starting SteamCMD update..."
$STEAMCMD_DIR/steamcmd.sh \
  +force_install_dir $GAME_DIR \
  +login anonymous \
  +app_update $APP_ID validate \
  +quit
  
export WINEDEBUG=-all

echo "Starting Game Server with Wine..."
cd $GAME_DIR
wine /home/steam/game/Moria/Binaries/Win64/MoriaServer-Win64-Shipping.exe