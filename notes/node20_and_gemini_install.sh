#!/usr/bin/env bash
set -euo pipefail

# Quick Node 20 setup snippet (if you only need Node.js):
#   curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
#   apt install -y nodejs

# Full setup with cleanup, Node 20, and Gemini CLI

echo "[+] Updating system"
apt update -y

echo "[+] Removing old Node if present"
apt remove -y nodejs npm 2>/dev/null || true

echo "[+] Installing Node 20"
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo "[+] Confirming Node version"
node -v
npm -v

echo "[+] Installing Gemini CLI"
npm install -g @google/gemini-cli

echo
echo "--------------------------------------------"
echo "Gemini CLI installed."
echo "Now set your API key:"
echo
echo 'export GEMINI_API_KEY="YOUR_KEY_HERE"' >> ~/.bashrc
echo "# Replace YOUR_KEY_HERE with your actual key"
echo
echo "Then reload shell:"
echo "  source ~/.bashrc"
echo
echo "Test:"
echo '  gemini "hello"'
echo "--------------------------------------------"
