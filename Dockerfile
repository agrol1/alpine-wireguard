FROM alpine:latest
LABEL maintainer "agrol1"
RUN apk add -U --no-cache --update wireguard-tools
RUN mkdir /util
COPY wg-startup.sh /util/wg-startup.sh
COPY docker-compose.yml /util/docker-compose.yml
RUN chmod 700 /util/wg-startup.sh
RUN addgroup -g 100 wgui
RUN adduser -D -u 100 -G wgui wgui
RUN echo "wgui ALL=(ALL) NOPASSWD: /usr/bin/wg-quick" >> /etc/sudoers.d/wgui
RUN chmod 0440 /etc/sudoers.d/wguiVOLUME /etc/wireguard/
EXPOSE 51820/udp
CMD /util/wg-startup.sh ; sleep infinity
