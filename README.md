# Linux Scripts

This repository collects a few small shell snippets for SSH configuration and developer setup reminders.

- **Notes** – A collection of commands for provisioning Node.js 20, installing the Gemini CLI, and managing SSH access (e.g., removing keys, adding users). It also contains a ready-to-run installation snippet that enables password-based SSH authentication and installs dependencies.
- **ssh access.sh** – Updates `/etc/ssh/sshd_config` to enable password and keyboard-interactive authentication, then restarts the SSH service.
- **ssh port forward** – Instructions for setting up SSH local port forwarding to complete device-based authentication flows from a workstation browser.

These scripts are intended to be run with appropriate privileges. Always review and adapt them to your environment before execution.
