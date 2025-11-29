#!/usr/bin/env bash
#If you are using gunicorn then enable line 3 and disable lines 4 and 5
#gunicorn --bind 0.0.0.0:5000 app:app --error-logfile /var/log/dnsresolver-error.log --log-level error &
export FLASK_APP=app.py
flask run --host=0.0.0.0 --port=5000 > /var/log/dnsresolver-error.log 2>&1 &
