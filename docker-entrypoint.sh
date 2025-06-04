#!/usr/bin/env bash
set -euo pipefail

echo "=== Docker Environment Setup ==="
echo "User: $(whoami)"
echo "Home: $HOME"
echo "Working directory: $(pwd)"
echo "Available files: $(ls -la)"

echo "=== Running Makefile Tests ==="
make full
