global
    maxconn 1000
    log stdout format raw local0

defaults
    log global
    timeout connect 5s
    timeout client  1m
    timeout server  1m

frontend postgres_front
    bind *:${PG_HAPROXY_PORT}
    mode tcp
    default_backend postgres_back

backend postgres_back
    mode tcp
    option httpchk GET /primary
    http-check expect status 200
    default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions

    server pg1 ${VM1_IP}:5432 check port 8008
    server pg2 ${VM2_IP}:5432 check port 8008

listen stats
    bind *:${PG_HAPROXY_STATS_PORT}
    mode http
    stats enable
    stats uri /stats
    stats refresh 5s
    stats auth ${HAPROXY_STATS_USER}:${HAPROXY_STATS_PASSWORD}
