#!/bin/bash

set -e

mkdir -p "$HOME/.local/bin"

cat >"$HOME/.local/bin/mirror" <<'EOF'
#!/bin/bash

xrandr --output HDMI-A-0 --mode 1920x1080 --same-as eDP
EOF
chmod +x "$HOME/.local/bin/mirror"
