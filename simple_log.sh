#!/usr/bin/env bash
set -euo pipefail
SIMPLE_LOG=$(bazel cquery --output=files //:simple_log --config=x86_64-linux 2>/dev/null | head -1)
export MW_LOG_CONFIG_FILE="$(pwd)/config/demo_app/logging.json"
exec "${SIMPLE_LOG}" "$@"
