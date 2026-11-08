#!/usr/bin/env bash
# Install dnsresolver as a systemd service so it starts on boot.
# Run as root:  sudo ./install-service.sh
set -e
app_dir="/opt/dnsresolver"
unit="dnsresolver.service"

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: run as root (sudo ./install-service.sh)."
    exit 1
fi
if [ ! -f "$app_dir/.env" ]; then
    echo "ERROR: $app_dir/.env not found. Create it with SECRET_KEY=<value> first."
    exit 1
fi
if [ ! -x "$app_dir/venv/bin/gunicorn" ]; then
    echo "ERROR: $app_dir/venv/bin/gunicorn not found. Run: $app_dir/venv/bin/pip install gunicorn"
    exit 1
fi

# Stop any copy started manually by start.sh so the port is free.
pids=$(lsof -t -i tcp:5001 2>/dev/null || true)
if [ -n "$pids" ] && ! systemctl is-active --quiet dnsresolver; then
    echo "Stopping manually started dnsresolver (PIDs: $(echo $pids))..."
    kill $pids || true
    sleep 2
fi

cp "$app_dir/$unit" "/etc/systemd/system/$unit"
systemctl daemon-reload
systemctl enable --now dnsresolver
systemctl --no-pager status dnsresolver
