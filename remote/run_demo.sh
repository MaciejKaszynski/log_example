#!/usr/bin/env bash
set -euo pipefail

RUNFILES_DIR="${RUNFILES_DIR:-$0.runfiles}"

# Cleanup the demo if killed
cleanup() {
    kill "${DATAROUTER_PID:-}" 2>/dev/null || true
    wait "${DATAROUTER_PID:-}" 2>/dev/null || true
    rm -rf "${DEMO_TARGET:-}"
}
trap cleanup EXIT

DATAROUTER_BIN="${RUNFILES_DIR}/$1"
SIMPLE_LOG_BIN="${RUNFILES_DIR}/$2"
LOG_CHANNELS_JSON="${RUNFILES_DIR}/$3"
DATAROUTER_LOGGING_JSON="${RUNFILES_DIR}/$4"
DEMO_APP_LOGGING_JSON="${RUNFILES_DIR}/$5"
shift 5

DEMO_TARGET=".demo_runtime/logging"
for arg in "$@"; do
    case "${arg}" in
        --target=*) DEMO_TARGET="${arg#--target=}" ;;
        *) echo "ERROR: unknown argument: ${arg}" >&2; exit 1 ;;
    esac
done
[[ "${DEMO_TARGET}" == /* ]] || DEMO_TARGET="${BUILD_WORKSPACE_DIRECTORY}/${DEMO_TARGET}"

mkdir -p "${DEMO_TARGET}/bin" "${DEMO_TARGET}/etc"
cp "${DATAROUTER_BIN}"          "${DEMO_TARGET}/bin/datarouter"
chmod +x                        "${DEMO_TARGET}/bin/datarouter"
cp "${SIMPLE_LOG_BIN}"          "${DEMO_TARGET}/bin/simple_log"
chmod +x                        "${DEMO_TARGET}/bin/simple_log"
cp "${LOG_CHANNELS_JSON}"       "${DEMO_TARGET}/etc/log-channels.json"
cp "${DATAROUTER_LOGGING_JSON}" "${DEMO_TARGET}/etc/logging.json"
cp "${DEMO_APP_LOGGING_JSON}"   "${DEMO_TARGET}/etc/demo_app.logging.json"

pkill -f "${DEMO_TARGET}/bin/datarouter" 2>/dev/null || true
sleep 0.3

cd "${DEMO_TARGET}"
MW_LOG_CONFIG_FILE="$(pwd)/etc/logging.json" ./bin/datarouter --no_adaptive_runtime &
DATAROUTER_PID=$!
echo "datarouter running (PID ${DATAROUTER_PID})"
sleep 1

echo ""
echo "Connect recieving application"
echo "dlt-receive -u -m 239.255.42.99 -p 3490 -a"
echo "Press Enter to start the demo app."
read -r

MW_LOG_CONFIG_FILE="$(pwd)/etc/demo_app.logging.json" ./bin/simple_log

