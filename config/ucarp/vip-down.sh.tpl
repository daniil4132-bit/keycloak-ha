#!/bin/bash
set -e

VIP="${VIP}"
INTERFACE="${INTERFACE}"

ip addr del "${VIP}/24" dev "${INTERFACE}" 2>/dev/null || true

logger "UCARP: VIP ${VIP} removed from ${INTERFACE}"
