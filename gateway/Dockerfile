FROM alpine:3.19
RUN apk add --no-cache curl iptables iproute2 dnsmasq dos2unix bash
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]