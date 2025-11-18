#!/usr/bin/env bash

# Configure SSH to allow password and keyboard-interactive authentication.
# Designed for use on fresh machines via: curl -fsSL <url>/ssh%20access.sh | sudo bash

set -euo pipefail

ensure_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "This script must be run as root. Re-run with sudo or as the root user." >&2
    exit 1
  fi
}

update_sshd_config() {
  local config_path="/etc/ssh/sshd_config"
  local backup_path="${config_path}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$config_path" "$backup_path"

  local tmp_file
  tmp_file=$(mktemp)

  awk '
    /^#?PasswordAuthentication/ {print "PasswordAuthentication yes"; next}
    /^#?KbdInteractiveAuthentication/ {print "KbdInteractiveAuthentication yes"; next}
    /^#?UsePAM/ {print "UsePAM yes"; next}
    {print}
  ' "$config_path" > "$tmp_file"

  cat "$tmp_file" > "$config_path"
  rm -f "$tmp_file"
}

restart_sshd() {
  if command -v systemctl >/dev/null 2>&1; then
    systemctl restart ssh || systemctl restart sshd
  else
    service ssh restart || service sshd restart
  fi
}

main() {
  ensure_root
  update_sshd_config
  restart_sshd
  echo "SSH configuration updated. Backup saved with timestamp; password login is now enabled."
}

main "$@"
