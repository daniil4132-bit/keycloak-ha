[Unit]
Description=Healthcheck for UCARP VIP failover
After=network-online.target docker.service ucarp.service
Wants=network-online.target

[Service]
Type=simple
ExecStart=/opt/keycloak-ha/scripts/ucarp-healthcheck.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
