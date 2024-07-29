#!/bin/bash
export DISPLAY=:99
export XAUTHORITY=/browser/.Xauthority

echo "---Starting Services---"
vncserver -geometry 1024x768 -depth 16 :99 -rfbport 5900 -noxstartup -securitytypes none 2>/dev/null
screen -d -m env HOME=/etc /usr/bin/fluxbox

while true; do
  trickle -d ${BANDWIDTH} -u ${BANDWIDTH} /usr/bin/google-chrome ${URL} -no-sandbox --disable-accelerated-video --bwsi --new-window --test-type --disable-accelerated-video --disable-gpu --dbus-stub --no-default-browser-check --no-first-run --bwsi --user-data-dir=/browser --disable-features=Titlebar --disable-dev-shm-usage --lang=${LANGUAGE}>/dev/null
done
