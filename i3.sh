#!/bin/bash

set -e

sudo apt update

sudo apt install -y x11-utils x11-xserver-utils \
    arandr lxappearance brightnessctl

sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee "/etc/X11/xorg.conf.d/00-keyboard.conf" >/dev/null <<'EOF'
Section "InputClass"
    Identifier "i3-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "us,gr"
    Option "XkbOptions" "grp:win_space_toggle"
EndSection
EOF

mkdir -p "$HOME/.local/bin"
cat >"$HOME/.local/bin/lock" <<'EOF'
#!/bin/bash

if pgrep -x i3lock >/dev/null; then
    exit
fi

i3lock --color "#000000"
EOF
chmod +x "$HOME/.local/bin/lock"

cat >"$HOME/.local/bin/screen-off" <<'EOF'
#!/bin/bash

xset dpms force off
EOF
chmod +x "$HOME/.local/bin/screen-off"

mkdir -p "$HOME/.config/i3"
cat >"$HOME/.config/i3/config" <<'EOF'
set $mod Mod1
set $mod2 Mod4

font pango:monospace 8

hide_edge_borders both

floating_modifier $mod

bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

bindsym $mod+b split h
bindsym $mod+v split v

bindsym $mod+f fullscreen

bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

bindsym $mod+Shift+space floating toggle

bindsym $mod+space focus mode_toggle

bindsym $mod+a focus parent

set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

bindsym $mod+Shift+1 move container to workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5
bindsym $mod+Shift+6 move container to workspace $ws6
bindsym $mod+Shift+7 move container to workspace $ws7
bindsym $mod+Shift+8 move container to workspace $ws8
bindsym $mod+Shift+9 move container to workspace $ws9
bindsym $mod+Shift+0 move container to workspace $ws10

bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6
bindsym $mod+7 workspace $ws7
bindsym $mod+8 workspace $ws8
bindsym $mod+9 workspace $ws9
bindsym $mod+0 workspace $ws10

bindsym $mod+Shift+r restart

mode "resize" {
    bindsym h resize shrink width 10 px or 10 ppt
    bindsym j resize grow height 10 px or 10 ppt
    bindsym k resize shrink height 10 px or 10 ppt
    bindsym l resize grow width 10 px or 10 ppt

    bindsym Return mode "default"
    bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

set $bg-color #2f343f
set $inactive-bg-color #2f343f
set $text-color #f3f4f5
set $inactive-text-color #676e7d
set $urgent-bg-color #e53935

client.focused $bg-color $bg-color $text-color #00ff00
client.unfocused $inactive-bg-color $inactive-bg-color $inactive-text-color #00ff00
client.focused_inactive $inactive-bg-color $inactive-bg-color $inactive-text-color #00ff00
client.urgent $urgent-bg-color $urgent-bg-color $text-color #00ff00

bar {
    status_command i3blocks

    colors {
        background $bg-color
        separator #757575
        focused_workspace $bg-color $bg-color $text-color
        inactive_workspace $inactive-bg-color $inactive-bg-color $inactive-text-color
        urgent_workspace $urgent-bg-color $urgent-bg-color $text-color
    }
}

bindsym $mod+Shift+s sticky toggle

assign [class="Zathura"] $ws1
assign [class="main"] $ws3
assign [class="VSCode"] $ws7
assign [class="jetbrains-idea"] $ws7
assign [class="firefox-esr"] $ws8
assign [class="discord"] $ws10

for_window [class="nmtui"] floating enable
for_window [workspace=$ws8] layout stacking

bindsym $mod+Return exec --no-startup-id alacritty
bindsym $mod+Shift+Return exec --no-startup-id alacritty --class="main"
bindsym $mod+Shift+q kill
bindsym $mod+d exec --no-startup-id dmenu_run
bindsym $mod2+l exec --no-startup-id "sleep 0.2 && ~/.local/bin/screen-off"
bindsym $mod2+Escape exec /usr/sbin/poweroff
bindsym $mod2+Shift+Escape exec /usr/sbin/reboot
bindsym $mod2+n exec --no-startup-id alacritty --class="nmtui" -e nmtui

bindsym $mod2+y exec --no-startup-id brightnessctl set 50%
bindsym $mod2+u exec --no-startup-id ~/.config/i3/brightness.sh down
bindsym $mod2+i exec --no-startup-id ~/.config/i3/brightness.sh up

bindsym $mod2+h exec --no-startup-id pamixer --toggle-mute
bindsym $mod2+j exec --no-startup-id pamixer --decrease 5
bindsym $mod2+k exec --no-startup-id pamixer --increase 5

bindsym $mod+Shift+g exec --no-startup-id firefox-esr --new-window
bindsym $mod+Shift+y exec --no-startup-id firefox-esr --new-window "youtube.com"
bindsym $mod+Shift+t exec --no-startup-id firefox-esr --new-window "github.com"
bindsym $mod+Shift+b exec --no-startup-id firefox-esr --new-window "gitlab.com"
bindsym $mod+Shift+m exec --no-startup-id firefox-esr --new-window "mail.google.com"

bindsym $mod+Shift+f exec --no-startup-id thunar
bindsym $mod+Shift+p exec --no-startup-id gimp
bindsym $mod+Shift+i exec --no-startup-id idea
bindsym $mod+Shift+d exec --no-startup-id discord

set $mon1 ""
set $mon2 ""
set $mon3 ""

#workspace $ws1 output $mon2
#workspace $ws2 output $mon2
#workspace $ws3 output $mon1
#workspace $ws4 output $mon1
#workspace $ws5 output $mon1
#workspace $ws6 output $mon1
#workspace $ws7 output $mon1
#workspace $ws8 output $mon3
#workspace $ws9 output $mon3
#workspace $ws10 output $mon3

exec_always --no-startup-id ~/.config/i3/monitors.sh
exec_always --no-startup-id feh --bg-scale ~/.config/i3/wallpaper.png

exec --no-startup-id xset b 0 0 0 s 00 dpms 0 0 0
exec --no-startup-id xss-lock --transfer-sleep-lock -- ~/.local/bin/lock
EOF

cat >"$HOME/.config/i3/brightness.sh" <<'EOF'
#!/bin/bash

cur=$(brightnessctl -m | cut -d, -f4 | tr -d '%')

case "$1" in
up)
    new=$((cur + 10))
    [ "$new" -gt 100 ] && new=100
    ;;
down)
    new=$((cur - 10))
    [ "$new" -lt 0 ] && new=0
    ;;
*)
    exit 1
    ;;
esac

brightnessctl set "${new}%"
EOF
chmod +x "$HOME/.config/i3/brightness.sh"

mkdir -p "$HOME/.config/i3blocks"
cat >"$HOME/.config/i3blocks/config" <<'EOF'
[cpu]
command=~/.config/i3blocks/cpu.sh
interval=10

[ram]
command=~/.config/i3blocks/ram.sh
interval=10

[disk]
command=~/.config/i3blocks/disk.sh
interval=60

[brightness]
command=~/.config/i3blocks/brightness.sh
interval=10

[volume]
command=~/.config/i3blocks/volume.sh
interval=1

[battery]
command=~/.config/i3blocks/battery.sh
interval=30

[date]
command=~/.config/i3blocks/date.sh
interval=60

[time]
command=~/.config/i3blocks/time.sh
interval=1

[keyboard]
command=~/.config/i3blocks/keyboard.sh
interval=1

[network]
command=~/.config/i3blocks/network.sh
interval=10
EOF

cat >"$HOME/.config/i3blocks/cpu.sh" <<'EOF'
#!/bin/bash

RED="#FF3333"
YELLOW="#FFFF00"
GREEN="#00FF00"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%.1f", 100 - $1}')

if (($(echo "$CPU_USAGE > 80" | bc -l))); then
    COLOR="$RED"
elif (($(echo "$CPU_USAGE > 50" | bc -l))); then
    COLOR="$YELLOW"
else
    COLOR="$GREEN"
fi

echo "CPU ${CPU_USAGE}%"
echo "CPU ${CPU_USAGE}%"
echo "$COLOR"
EOF
chmod +x "$HOME/.config/i3blocks/cpu.sh"

cat >"$HOME/.config/i3blocks/ram.sh" <<'EOF'
#!/bin/bash

RED="#FF3333"
YELLOW="#FFFF00"
GREEN="#00FF00"

RAM_USAGE=$(free | awk '/Mem/ {printf "%.1f", $3/$2 * 100}')

if (($(echo "$RAM_USAGE > 80" | bc -l))); then
    COLOR="$RED"
elif (($(echo "$RAM_USAGE > 60" | bc -l))); then
    COLOR="$YELLOW"
else
    COLOR="$GREEN"
fi

echo "RAM ${RAM_USAGE}%"
echo "RAM ${RAM_USAGE}%"
echo "$COLOR"
EOF
chmod +x "$HOME/.config/i3blocks/ram.sh"

cat >"$HOME/.config/i3blocks/disk.sh" <<'EOF'
#!/bin/bash

RED="#FF3333"
YELLOW="#FFFF00"
GREEN="#00FF00"

USAGE_PERCENT=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2}')

if [ "$USAGE_PERCENT" -ge 90 ]; then
    COLOR="$RED"
elif [ "$USAGE_PERCENT" -ge 80 ]; then
    COLOR="$YELLOW"
else
    COLOR="$GREEN"
fi

echo "DISK $DISK_USAGE"
echo "DISK $DISK_USAGE"
echo "$COLOR"
EOF
chmod +x "$HOME/.config/i3blocks/disk.sh"

cat >"$HOME/.config/i3blocks/brightness.sh" <<'EOF'
#!/bin/bash

BRIGHTNESS=$(brightnessctl -m | cut -d, -f4)
echo "BRI $BRIGHTNESS"
EOF
chmod +x "$HOME/.config/i3blocks/brightness.sh"

cat >"$HOME/.config/i3blocks/volume.sh" <<'EOF'
#!/bin/bash

MUTE=$(pamixer --get-mute)

if [ "$MUTE" = "true" ]; then
    echo "MUTED"
    exit 0
fi

VOLUME=$(pamixer --get-volume)
echo "VOL $VOLUME%"
EOF
chmod +x "$HOME/.config/i3blocks/volume.sh"

cat >"$HOME/.config/i3blocks/battery.sh" <<'EOF'
#!/bin/bash

RED="#FF3333"
YELLOW="#FFFF00"
GREEN="#00FF00"

BATTERY="/sys/class/power_supply/BAT0"

if [ ! -d "$BATTERY" ]; then
    echo "No battery"
    exit 0
fi

STATUS=$(cat "$BATTERY/status")
CAPACITY=$(cat "$BATTERY/capacity")

STATE_FILE="/tmp/battery-notification"

notify_charged_battery() {
    local capacity="$1"
    local level="80"

    if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" != "$level" ]; then
        notify-send \
            -u normal \
            "Battery charged" \
            "${capacity}% battery charged."

        echo "$level" >"$STATE_FILE"
    fi
}

notify_full_battery() {
    local capacity="$1"
    local level="FULL"

    if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" != "$level" ]; then
        notify-send \
            -u critical \
            "Battery full" \
            "${capacity}% battery charged."

        echo "$level" >"$STATE_FILE"
    fi
}

notify_low_battery() {
    local capacity="$1"
    local level

    if [ "$capacity" -le 5 ]; then
        level="LOW 5"
    else
        level="LOW 20"
    fi

    if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" != "$level" ]; then
        notify-send \
            -u critical \
            "Battery low" \
            "${capacity}% battery remaining."

        echo "$level" >"$STATE_FILE"
    fi
}

notify_not_charging_battery() {
    local capacity="$1"
    local level="NOT CHG"

    if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" != "$level" ]; then
        notify-send \
            -u critical \
            "Battery not charging" \
            "${capacity}% battery remaining."

        echo "$level" >"$STATE_FILE"
    fi
}

if [ "$STATUS" = "Charging" ]; then
    LABEL="CHG"

    if [ "$CAPACITY" -ge 80 ]; then
        COLOR="$RED"
        notify_charged_battery "$CAPACITY"
    elif [ "$CAPACITY" -ge 70 ]; then
        COLOR="$YELLOW"
        echo "CHG" >"$STATE_FILE"
    else
        COLOR="$GREEN"
        echo "CHG" >"$STATE_FILE"
    fi
elif [ "$STATUS" = "Full" ]; then
    LABEL="CHG"
    COLOR="$RED"

    notify_full_battery "$CAPACITY"
elif [ "$STATUS" = "Discharging" ]; then
    LABEL="BAT"

    if [ "$CAPACITY" -le 20 ]; then
        COLOR="$RED"
        notify_low_battery "$CAPACITY"
    elif [ "$CAPACITY" -le 30 ]; then
        COLOR="$YELLOW"
        echo "BAT" >"$STATE_FILE"
    else
        COLOR="$GREEN"
        echo "BAT" >"$STATE_FILE"
    fi
elif [ "$STATUS" = "Not charging" ]; then
    LABEL="NOT CHG"
    COLOR="$RED"

    notify_not_charging_battery "$CAPACITY"
else
    LABEL="UNKNOWN"
    COLOR="$YELLOW"

    rm -f "$STATE_FILE"
fi

echo "$LABEL $CAPACITY%"
echo "$LABEL $CAPACITY%"
echo "$COLOR"
EOF
chmod +x "$HOME/.config/i3blocks/battery.sh"

cat >"$HOME/.config/i3blocks/date.sh" <<'EOF'
#!/bin/bash

date "+%Y-%m-%d"
EOF
chmod +x "$HOME/.config/i3blocks/date.sh"

cat >"$HOME/.config/i3blocks/time.sh" <<'EOF'
#!/bin/bash

date "+%H:%M:%S"
EOF
chmod +x "$HOME/.config/i3blocks/time.sh"

cat >"$HOME/.config/i3blocks/keyboard.sh" <<'EOF'
#!/bin/bash

BLUE="#3399FF"
RED="#FF3333"

LED=$(xset -q | awk '/LED mask:/ {print $10}')

COLOR="$BLUE"
case "$LED" in
00000000)
    LAYOUT="US"
    ;;
00001000)
    LAYOUT="GR"
    ;;
*)
    LAYOUT="??"
    COLOR="$RED"
    ;;
esac

echo "$LAYOUT"
echo "$LAYOUT"
echo "$COLOR"
EOF
chmod +x "$HOME/.config/i3blocks/keyboard.sh"

cat >"$HOME/.config/i3blocks/network.sh" <<'EOF'
#!/bin/bash

SSID=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')

if [ -z "$SSID" ]; then
    echo "No network"
    exit 0
fi

echo "$SSID"
EOF
chmod +x "$HOME/.config/i3blocks/network.sh"

mv wallpaper.png "$HOME/.config/i3/wallpaper.png"
