[Unit]
Description=UCARP VIP service for Keycloak HA
After=network-online.target docker.service
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/sbin/ucarp \
  -i ${INTERFACE} \
  -s ${HOST_IP} \
  -v ${UCARP_VHID} \
  -p ${UCARP_PASSWORD} \
  -a ${VIP} \
  -u /opt/keycloak-ha/scripts/vip-up.sh \
  -d /opt/keycloak-ha/scripts/vip-down.sh \
  -k ${UCARP_ADVSKEW}
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
