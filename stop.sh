#!/usr/bin/env bash
# If installed as a systemd service, let systemd manage it.
if command -v systemctl >/dev/null 2>&1 && systemctl is-enabled --quiet dnsresolver 2>/dev/null; then
    exec systemctl stop dnsresolver
fi
pid_status=$(lsof -i tcp:5001 | awk {'print $2'} |grep -v PID)
kill -9 $pid_status
