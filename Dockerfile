FROM debian:stable-slim

ENV TURBOVNC_V="3.0.3"
ENV SERVICE_NAME="UNDEFINED"
ENV WEBHOOK_URL="http://localhost/"
ENV URL=https://google.com/
ENV BANDWIDTH=15000
ENV LANGUAGE="en"

RUN  echo "deb http://deb.debian.org/debian bullseye contrib non-free" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get -qqy install --no-install-recommends feh wget procps xvfb wmctrl x11vnc fluxbox screen libxcomposite-dev libxcursor1 xauth python3 supervisor dbus-x11 x11-xserver-utils curl unzip gettext pulseaudio pavucontrol trickle lame ffmpeg fonts-takao fonts-arphic-uming libgtk-3-0 libgconf-2-4 libnss3 fonts-liberation fonts-noto fonts-noto-cjk fonts-noto-color-emoji fonts-noto-mono fonts-arphic-ukai fonts-indic fonts-thai-tlwg libasound2 libcurl3-gnutls libcurl3-nss libcurl4 libgbm1 libnspr4 libnss3 libu2f-udev xdg-utils && \
	apt-get -y install --reinstall ca-certificates && \
	rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
	wget -O /tmp/turbovnc.deb https://sourceforge.net/projects/turbovnc/files/3.1/turbovnc_3.1_amd64.deb/download && \
	dpkg -i /tmp/turbovnc.deb && \
	rm -rf /opt/TurboVNC/java /opt/TurboVNC/README.txt && \
	cp -R /opt/TurboVNC/bin/* /bin/ && \
	rm -rf /opt/TurboVNC /tmp/turbovnc.deb && \
	sed -i '/# $enableHTTP = 1;/c\$enableHTTP = 0;' /etc/turbovncserver.conf


RUN mkdir /browser && \
	mkdir /opt/scripts && \
	mkdir /app && \
	useradd -d /browser -s /bin/bash "browser" && \
	chown -R "browser" /browser && \
	ulimit -n 2048

COPY /scripts /opt/scripts/

COPY /fluxbox/ /etc/.fluxbox/
RUN chmod -R 770 /opt/scripts/
RUN mv /etc/.fluxbox/theme.cfg /usr/share/fluxbox/styles/Squared_for_Debian/theme.cfg -f


RUN adduser root pulse-access
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu

# ------------ Install Browser ------------
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
RUN dpkg -i /tmp/chrome.deb || apt-get install -yf
RUN rm /tmp/chrome.deb
# ------------ End Install Browser ------------

#Server Start
CMD ["bash", "/opt/scripts/start.sh"]