#!/usr/bin/env bash
set -euo pipefail

# Allow local root to access X server when available.
# Prefer a scoped permission; fall back to the broader local:root.
if command -v xhost >/dev/null 2>&1; then
  xhost +SI:localuser:root >/dev/null 2>&1 || \
  xhost +local:root >/dev/null 2>&1 || true
fi

exit 0

