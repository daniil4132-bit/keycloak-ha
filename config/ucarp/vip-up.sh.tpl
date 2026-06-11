#!/bin/bash
set -e

VIP="${VIP}"
INTERFACE="${INTERFACE}"

ip addr show dev "${INTERFACE}" | grep -q "${VIP}/24" || ip addr add "${VIP}/24" dev "${INTERFACE}"

if command -v arping >/dev/null 2>&1; then
    arping -q -c 3 -A -I "${INTERFACE}" "${VIP}" || true
fi

logger "UCARP: VIP ${VIP} added on ${INTERFACE}"
