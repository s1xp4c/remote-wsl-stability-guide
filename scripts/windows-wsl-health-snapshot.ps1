wsl --status
wsl -l -v
wsl -d Ubuntu -e bash -lc "echo '--- kernel ---'; uname -a; echo; echo '--- uptime/mem ---'; uptime; free -h; echo; echo '--- swap ---'; swapon --show || true; echo; echo '--- top mem ---'; ps -eo pid,cmd,%cpu,%mem --sort=-%mem | head -n 15; echo; echo '--- last OOM lines ---'; dmesg -T | egrep -i 'out of memory|oom-kill|killed process' | tail -n 20 || true"
