#!/bin/bash

HEALTHCHECK_URL="${UCARP_HEALTHCHECK_URL}"
INTERVAL="${UCARP_HEALTHCHECK_INTERVAL}"
TIMEOUT="${UCARP_HEALTHCHECK_TIMEOUT}"
MAX_FAILS="${UCARP_HEALTHCHECK_FAILS}"
SUCCESS_TO_REJOIN="${UCARP_HEALTHCHECK_SUCCESS_TO_REJOIN}"

FAIL_COUNT=0
SUCCESS_COUNT=0
UCARP_STOPPED_BY_HEALTHCHECK=0

logger "UCARP healthcheck started. URL=${HEALTHCHECK_URL}, interval=${INTERVAL}, timeout=${TIMEOUT}, max_fails=${MAX_FAILS}, success_to_rejoin=${SUCCESS_TO_REJOIN}"

is_ucarp_active() {
    systemctl is-active --quiet ucarp
}

while true; do
    if curl -fsS --max-time "${TIMEOUT}" "${HEALTHCHECK_URL}" >/dev/null 2>&1; then
        FAIL_COUNT=0
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))

        if [ "${UCARP_STOPPED_BY_HEALTHCHECK}" -eq 1 ]; then
            logger "UCARP healthcheck success ${SUCCESS_COUNT}/${SUCCESS_TO_REJOIN}. Waiting before rejoining UCARP."

            if [ "${SUCCESS_COUNT}" -ge "${SUCCESS_TO_REJOIN}" ]; then
                logger "Local service is stable again. Starting ucarp to rejoin as backup if another master is active."
                systemctl start ucarp
                UCARP_STOPPED_BY_HEALTHCHECK=0
                SUCCESS_COUNT=0
            fi
        fi
    else
        SUCCESS_COUNT=0
        FAIL_COUNT=$((FAIL_COUNT + 1))

        logger "UCARP healthcheck failed ${FAIL_COUNT}/${MAX_FAILS}. URL=${HEALTHCHECK_URL}"

        if [ "${FAIL_COUNT}" -ge "${MAX_FAILS}" ]; then
            if is_ucarp_active; then
                logger "Failure threshold reached. Stopping ucarp to release VIP."
                systemctl stop ucarp
                UCARP_STOPPED_BY_HEALTHCHECK=1
            else
                logger "Failure threshold reached, but ucarp is already inactive."
                UCARP_STOPPED_BY_HEALTHCHECK=1
            fi

            FAIL_COUNT=0
        fi
    fi

    sleep "${INTERVAL}"
done
