#!/bin/sh
sleep 15
cd /etc/wireguard/

if [ ! -f wg0.conf ]
then
    echo "wg0.conf not found creating a temporary config"
    echo "[Interface]" > wg0.conf
    echo "Address = 192.168.254.1/24" >> wg0.conf 
    echo "ListenPort = 51820" >> wg0.conf 
    echo "PrivateKey = KYO+8vxJh6p3FspHklrPG4HTdWZ7GIMs/zMmbSn9N0U=" >> wg0.conf 
    echo "MTU = 1450" >> wg0.conf
    echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> wg0.conf
    echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE" >> wg0.conf 
    echo "[Peer]" >> wg0.conf
    echo "PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU=" >> wg0.conf 
    echo "PresharedKey = /UwcSPg38hW/D9Y3tcS1FOV0K1wuURMbS0sesJEP5ak=" >> wg0.conf
    echo "AllowedIPs = 192.168.254.2/32" >> wg0.conf
    echo "Endpoint = demo.wireguard.com:51820" >> wg0.conf
    chmod 600 wg0.conf
    wg-quick up wg0
    wg show
else
    echo "wg0.conf found starting up the interface"
    wg-quick up wg0
    wg show
fi
