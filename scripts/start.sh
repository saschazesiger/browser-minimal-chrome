#!/bin/bash
echo "---Ensuring UID: 99 matches user---"
usermod -u 99 browser
echo "---Ensuring GID: 100 matches user---"
groupmod -g 100 browser > /dev/null 2>&1 ||:
usermod -g 100 browser
echo "---Setting umask to 000---"
umask 000

HOST=$(cat /hostname)

echo "---Taking ownership of data...---"
chown -R root:100 /opt/scripts
chmod -R 750 /opt/scripts
chown -R browser:browser /browser
chown -R browser:browser /browserdata

echo "---Starting...---"
term_handler() {
	kill -SIGTERM "$killpid"
	wait "$killpid" -f 2>/dev/null
	exit 143;
}

echo "---Checking for old logfiles---"
find /browser -name "XvfbLog.*" -exec rm -f {} \;
find /browser -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old display lock files---"
rm -rf /tmp/.X99*
rm -rf /tmp/.X11*
rm -rf /browser/.vnc/*.log /browser/.vnc/*.pid /browser/Singleton*
screen -wipe 2&>/dev/null

trap 'kill ${!}; term_handler' SIGTERM

su browser -c "/opt/scripts/start-server.sh" &
killpid="$!"
while true
do
	wait $killpid
	exit 0;
done