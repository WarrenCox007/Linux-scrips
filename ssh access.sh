#!/usr/bin/env bash

# Configure SSH to allow password and keyboard-interactive authentication.
# Designed for use on fresh machines via: curl -fsSL <url>/ssh%20access.sh | sudo bash

#bash -c "$(curl -fsSL https://raw.githubusercontent.com/WarrenCox007/Linux-scrips/main/ssh%20access.sh)"

#!/usr/bin/env bash

# Enable SSH password & keyboard-interactive auth safely
# Usage:
# curl -fsSL https://raw.githubusercontent.com/WarrenCox007/Linux-scrips/main/ssh%20access.sh | sudo bash

set -euo pipefail

ensure_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "This script must be run as root. Re-run with sudo or as root." >&2
    exit 1
  fi
}

update_sshd_config() {
  local config_path="/etc/ssh/sshd_config"
  local backup_path="${config_path}.bak.$(date +%Y%m%d%H%M%S)"

  cp "$config_path" "$backup_path"

  local tmp
  tmp="$(mktemp)"

  awk '
    BEGIN {
      found_pass = 0
      found_kbd = 0
      found_pam = 0
    }

    /^#?PasswordAuthentication/ {
      print "PasswordAuthentication yes"
      found_pass = 1
      next
    }

    /^#?KbdInteractiveAuthentication/ {
      print "KbdInteractiveAuthentication yes"
      found_kbd = 1
      next
    }

    /^#?UsePAM/ {
      print "UsePAM yes"
      found_pam = 1
      next
    }

    { print }

    END {
      if (!found_pass) print "PasswordAuthentication yes"
      if (!found_kbd) print "KbdInteractiveAuthentication yes"
      if (!found_pam) print "UsePAM yes"
    }
  ' "$config_path" > "$tmp"

  # Validate before applying
  cp "$tmp" "$config_path"
  if ! sshd -t; then
    echo "Error: SSH config validation failed. Restoring backup."
    cp "$backup_path" "$config_path"
    exit 1
  fi

  mv "$tmp" "$config_path"
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
  echo "SSH config updated safely. Backup created: $(ls /etc/ssh/sshd_config.bak.* | tail -1)"
}

main "$@"
