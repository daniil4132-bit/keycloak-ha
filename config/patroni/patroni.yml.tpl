scope: ${PATRONI_SCOPE}
namespace: /service/
name: ${PATRONI_NAME}

restapi:
  listen: 0.0.0.0:8008
  connect_address: ${HOST_IP}:8008

etcd3:
  hosts:
    - ${VM1_IP}:2379
    - ${VM2_IP}:2379
    - ${VM3_IP}:2379

bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    synchronous_mode: true
    synchronous_mode_strict: false
    postgresql:
      use_pg_rewind: true
      use_slots: true
      parameters:
        wal_level: replica
        hot_standby: "on"
        wal_keep_size: 128MB
        max_wal_senders: 10
        max_replication_slots: 10
        max_connections: 200
        shared_buffers: 256MB
        synchronous_commit: "on"

  initdb:
    - encoding: UTF8
    - data-checksums

  pg_hba:
    - host all all 0.0.0.0/0 md5
    - host replication ${REPLICATION_USERNAME} 0.0.0.0/0 md5

  users:
    admin:
      password: ${POSTGRES_PASSWORD}
      options:
        - createrole
        - createdb

postgresql:
  listen: 0.0.0.0:5432
  connect_address: ${HOST_IP}:5432
  data_dir: /var/lib/postgresql/data/pgdata
  bin_dir: /usr/lib/postgresql/16/bin

  authentication:
    superuser:
      username: postgres
      password: ${POSTGRES_PASSWORD}
    replication:
      username: ${REPLICATION_USERNAME}
      password: ${REPLICATION_PASSWORD}

  parameters:
    unix_socket_directories: /var/run/postgresql
    password_encryption: scram-sha-256

tags:
  nofailover: false
  noloadbalance: false
  clonefrom: false
  nosync: false
