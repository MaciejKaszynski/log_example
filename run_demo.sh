#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Paths — override with environment variables if needed
# ---------------------------------------------------------------------------
DATAROUTER_BIN="${DATAROUTER_BIN:-/opt/datarouter/bin/datarouter}"
DEMO_BIN="${DEMO_BIN:-${SCRIPT_DIR}/bazel-bin/simple_log}"

# ---------------------------------------------------------------------------
# Sanity checks
# ---------------------------------------------------------------------------
if [[ ! -x "${DATAROUTER_BIN}" ]]; then
    echo "ERROR: datarouter binary not found at '${DATAROUTER_BIN}'"
    echo "  Build it from score/logging:"
    echo "    bazel build --config=spp_host_gcc //score/datarouter:datarouter"
    echo "  Then copy to /opt/datarouter/bin/ or set DATAROUTER_BIN=<path>"
    exit 1
fi

if [[ ! -x "${DEMO_BIN}" ]]; then
    echo "INFO: demo binary not found, building now..."
    (cd "${SCRIPT_DIR}" && bazel build --config=spp_host_gcc //:simple_log)
fi

# ---------------------------------------------------------------------------
# Enable multicast on the loopback interface (required for DLT UDP)
# ---------------------------------------------------------------------------
if ! ip link show lo | grep -q "MULTICAST"; then
    echo "INFO: enabling multicast on loopback (requires sudo)"
    sudo ip link set lo multicast on
fi

# ---------------------------------------------------------------------------
# Deploy configs
# ---------------------------------------------------------------------------
echo "INFO: deploying configs..."
sudo mkdir -p /opt/simple_log/etc /opt/datarouter/etc

sudo cp "${SCRIPT_DIR}/config/demo_app/logging.json"       /opt/simple_log/etc/logging.json
sudo cp "${SCRIPT_DIR}/config/datarouter/log-channels.json" /opt/datarouter/etc/log-channels.json
sudo cp "${SCRIPT_DIR}/config/datarouter/logging.json"      /opt/datarouter/etc/logging.json

# ---------------------------------------------------------------------------
# Start datarouter (kill any existing instance first)
# ---------------------------------------------------------------------------
echo "INFO: starting datarouter..."
pkill -f "datarouter --no_adaptive_runtime" 2>/dev/null || true
sleep 0.3

"${DATAROUTER_BIN}" --no_adaptive_runtime &
DATAROUTER_PID=$!
echo "INFO: datarouter running (PID ${DATAROUTER_PID})"

# Give the daemon time to bind its shared memory and socket
sleep 1

# ---------------------------------------------------------------------------
# dlt-viewer hint
# ---------------------------------------------------------------------------
echo ""
echo "============================================================"
echo "  Open dlt-viewer now and connect via:"
echo "    Protocol : UDP"
echo "    Host     : 127.0.0.1"
echo "    Port     : 3490"
echo "  Then press Enter here to start the demo app."
echo "============================================================"
read -r

# ---------------------------------------------------------------------------
# Run the demo app
# ---------------------------------------------------------------------------
echo "INFO: running demo app..."
"${DEMO_BIN}"

# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------
echo "INFO: stopping datarouter..."
kill "${DATAROUTER_PID}" 2>/dev/null || true
wait "${DATAROUTER_PID}" 2>/dev/null || true
echo "INFO: done."
