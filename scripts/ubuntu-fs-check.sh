#!/usr/bin/env bash
set -euo pipefail
echo "PWD: $(pwd)"
df -T . | tail -n 1
