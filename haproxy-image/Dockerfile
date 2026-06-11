FROM postgres:16-bookworm

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends haproxy ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["haproxy"]
CMD ["-f", "/usr/local/etc/haproxy/haproxy.cfg", "-db"]
