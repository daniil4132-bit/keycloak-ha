FROM postgres:16-bookworm

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3 \
       python3-pip \
       python3-venv \
       curl \
       ca-certificates \
    && pip3 install --break-system-packages --no-cache-dir \
       "patroni[etcd3,psycopg3]" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER postgres

ENTRYPOINT ["patroni"]
CMD ["/etc/patroni/patroni.yml"]
