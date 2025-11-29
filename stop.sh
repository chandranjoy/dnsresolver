#!/usr/bin/env bash
pid_status=$(lsof -i tcp:5000 | awk {'print $2'} |grep -v PID)
kill -9 $pid_status
