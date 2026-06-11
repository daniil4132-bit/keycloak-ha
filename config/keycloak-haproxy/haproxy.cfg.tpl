global
    maxconn 2000
    log stdout format raw local0

defaults
    log global
    mode http
    timeout connect 5s
    timeout client  1m
    timeout server  1m
    option httplog

frontend keycloak_front
    bind *:${KEYCLOAK_HAPROXY_PORT}
    mode http

    option forwardfor

    http-request set-header Host ${VIP}
    http-request set-header X-Forwarded-Proto http
    http-request set-header X-Forwarded-Port ${KEYCLOAK_HAPROXY_PORT}
    http-request set-header X-Forwarded-Host ${VIP}

    default_backend keycloak_back

backend keycloak_back
    mode http
    balance roundrobin

    option httpchk
    http-check send meth GET uri /realms/master ver HTTP/1.1 hdr Host ${VIP} hdr X-Forwarded-Proto http hdr X-Forwarded-Port ${KEYCLOAK_HAPROXY_PORT} hdr X-Forwarded-Host ${VIP}
    http-check expect status 200

    default-server inter 3s fall 3 rise 2

    server kc1 ${VM1_IP}:${KEYCLOAK_HTTP_PORT} check
    server kc2 ${VM2_IP}:${KEYCLOAK_HTTP_PORT} check

listen stats
    bind *:${KEYCLOAK_HAPROXY_STATS_PORT}
    mode http
    stats enable
    stats uri /stats
    stats refresh 5s
    stats auth ${HAPROXY_STATS_USER}:${HAPROXY_STATS_PASSWORD}
