#!/bin/bash

set -e

sudo mkdir -p /etc/systemd/logind.conf.d
sudo tee "/etc/systemd/logind.conf.d/sleep-operation.conf" >/dev/null <<'EOF'
[Login]
SleepOperation=suspend
EOF

mkdir -p "$HOME/.local/bin"
cat >"$HOME/.local/bin/idle-monitor" <<'EOF'
#!/bin/bash

IDLE_OFF=600000 # 10 minutes
IDLE_SLEEP=7200000 # 2 hours

OFF_TRIGGERED=0
SLEEP_TRIGGERED=0

while true; do
    IDLE=$(xprintidle)

    if [ "$IDLE" -ge "$IDLE_OFF" ] && [ "$OFF_TRIGGERED" -eq 0 ]; then
        ~/.local/bin/screen-off
        OFF_TRIGGERED=1
    fi

    if [ "$IDLE" -ge "$IDLE_SLEEP" ] && [ "$SLEEP_TRIGGERED" -eq 0 ]; then
        systemctl sleep
        SLEEP_TRIGGERED=1
    fi

    if [ "$IDLE" -lt "$IDLE_OFF" ]; then
        OFF_TRIGGERED=0
        SLEEP_TRIGGERED=0
    fi

    sleep 5
done
EOF
chmod +x "$HOME/.local/bin/idle-monitor"

mkdir -p "$HOME/.config/systemd/user"
cat >"$HOME/.config/systemd/user/idle-monitor.service" <<EOF
[Unit]
Description=Automatic Screen Locker

[Service]
Type=simple
Environment=DISPLAY=:0
Environment=XAUTHORITY=%h/.Xauthority
ExecStart=%h/.local/bin/idle-monitor.sh
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now idle-monitor.service
