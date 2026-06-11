#!/usr/bin/env python3

import os
from pathlib import Path
from string import Template

PROJECT_DIR = Path("/opt/keycloak-ha")

FILES = [
    # Patroni
    ("config/patroni/patroni.yml.tpl", "config/patroni/patroni.yml"),

    # HAProxy
    ("config/pg-haproxy/haproxy.cfg.tpl", "config/pg-haproxy/haproxy.cfg"),
    ("config/keycloak-haproxy/haproxy.cfg.tpl", "config/keycloak-haproxy/haproxy.cfg"),

    # UCARP
    ("config/ucarp/vip-up.sh.tpl", "scripts/vip-up.sh"),
    ("config/ucarp/vip-down.sh.tpl", "scripts/vip-down.sh"),
    ("config/ucarp/ucarp.service.tpl", "config/ucarp/ucarp.service"),
    ("config/ucarp/ucarp-healthcheck.sh.tpl", "scripts/ucarp-healthcheck.sh"),
    ("config/ucarp/ucarp-healthcheck.service.tpl", "config/ucarp/ucarp-healthcheck.service"),
]

for src, dst in FILES:
    src_path = PROJECT_DIR / src
    dst_path = PROJECT_DIR / dst

    if not src_path.exists():
        print(f"SKIP: template not found: {src_path}")
        continue

    dst_path.parent.mkdir(parents=True, exist_ok=True)

    tpl = src_path.read_text()
    dst_path.write_text(Template(tpl).safe_substitute(os.environ))

    print(f"Rendered: {src} -> {dst}")
