#!/usr/bin/env bash
set -euo pipefail
DATAROUTER="/home/kam1yok/.cache/bazel/_bazel_kam1yok/6ad6453cd3aa43f75da309a5d76cdb3e/execroot/_main/bazel-out/k8-fastbuild/bin/external/score_logging+/score/datarouter/datarouter"
if ! ip link show lo | grep -q MULTICAST; then
    echo "WARNING: multicast not enabled on loopback — dlt-receive/dlt-viewer will not receive packets"
    echo "  Run: sudo ip link set lo multicast on"
fi
mkdir -p etc
cp config/datarouter/log-channels.json etc/log-channels.json
export MW_LOG_CONFIG_FILE="$(pwd)/config/datarouter/logging.json"
exec "${DATAROUTER}"
