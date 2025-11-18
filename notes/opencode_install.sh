#!/usr/bin/env bash
set -euo pipefail

# Load existing shell configuration before running installers.
source "${HOME}/.bashrc"

# Install the Opencode tooling bundle.
bash -c "$(curl -fsSL https://raw.githubusercontent.com/WarrenCox007/Opencode/main/install_opencode_full.sh)"
