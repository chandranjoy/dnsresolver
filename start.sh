#!/usr/bin/env bash
log_file="/var/log/dnsresolver-error.log"
app_dir="/opt/dnsresolver"
app_port="5001"
app_host="127.0.0.1"

# SECRET_KEY must be set before starting.
# Either export it in the environment or place it in $app_dir/.env
if [ -f "$app_dir/.env" ]; then
    set -a
    # shellcheck source=/dev/null
    source "$app_dir/.env"
    set +a
fi

if [ -z "$SECRET_KEY" ]; then
    echo "ERROR: SECRET_KEY is not set. Create $app_dir/.env with SECRET_KEY=<value>."
    exit 1
fi

cd "$app_dir"
source venv/bin/activate
gunicorn --bind "$app_host:$app_port" app:app --error-logfile "$log_file" --log-level error &
