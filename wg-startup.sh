#!/bin/sh

CONFIG_FILE="/etc/wireguard/wg0.conf"

# Vänta 15 sekunder vid uppstart
sleep 15
cd /etc/wireguard/

# Om wg0.conf inte finns, skapa en standardkonfiguration
if [ ! -f "$CONFIG_FILE" ]; then
    echo "wg0.conf not found, creating a temporary config..."
    cat <<EOL > "$CONFIG_FILE"
[Interface]
Address = 192.168.254.1/24
ListenPort = 51820
PrivateKey = KYO+8vxJh6p3FspHklrPG4HTdWZ7GIMs/zMmbSn9N0U=
MTU = 1450
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU=
PresharedKey = /UwcSPg38hW/D9Y3tcS1FOV0K1wuURMbS0sesJEP5ak=
AllowedIPs = 192.168.254.2/32
Endpoint = demo.wireguard.com:51820
EOL

    chmod 600 "$CONFIG_FILE"
    echo "Temporary wg0.conf created."
fi

# Starta WireGuard
echo "Starting WireGuard..."
wg-quick up wg0
wg show

# Övervaka ändringar i wg0.conf och starta om vid behov
echo "Monitoring $CONFIG_FILE for changes..."
apk add --no-cache inotify-tools

while inotifywait -e modify "$CONFIG_FILE"; do
    echo "Change detected in $CONFIG_FILE, restarting WireGuard..."
    wg-quick down wg0
    wg-quick up wg0
    wg show
done
