#!/usr/bin/env bash
# If installed as a systemd service, let systemd manage it.
if command -v systemctl >/dev/null 2>&1 && systemctl is-enabled --quiet dnsresolver 2>/dev/null; then
    exec systemctl restart dnsresolver
fi
# Restart dnsresolver: stop the running gunicorn on $app_port, wait for the
# port to free up, then launch it again via start.sh.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
app_port="5001"

pids=$(lsof -t -i tcp:"$app_port" 2>/dev/null)
if [ -n "$pids" ]; then
    echo "Stopping dnsresolver (PIDs: $(echo $pids))..."
    kill $pids 2>/dev/null

    # Give gunicorn up to 10s to shut down gracefully, then force it.
    for _ in $(seq 1 10); do
        lsof -t -i tcp:"$app_port" >/dev/null 2>&1 || break
        sleep 1
    done
    pids=$(lsof -t -i tcp:"$app_port" 2>/dev/null)
    if [ -n "$pids" ]; then
        echo "Graceful stop timed out, forcing..."
        kill -9 $pids 2>/dev/null
        sleep 1
    fi
else
    echo "dnsresolver is not running on port $app_port."
fi

echo "Starting dnsresolver..."
"$script_dir/start.sh" || exit 1

# Confirm it came up.
for _ in $(seq 1 10); do
    if lsof -t -i tcp:"$app_port" >/dev/null 2>&1; then
        echo "dnsresolver is running on port $app_port."
        exit 0
    fi
    sleep 1
done
echo "ERROR: dnsresolver did not start. Check /var/log/dnsresolver-error.log"
exit 1
