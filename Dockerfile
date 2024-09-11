FROM alpine:latest
LABEL maintainer "agrol1"
RUN apk add -U --no-cache --update wireguard-tools
RUN mkdir /util
COPY wg-startup.sh /util/wg-startup.sh
COPY docker-compose.yml /util/docker-compose.yml
RUN chmod 700 /util/wg-startup.sh
VOLUME /etc/wireguard/
EXPOSE 51820/udp
CMD /util/wg-startup.sh ; sleep infinity
