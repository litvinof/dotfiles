#!/usr/bin/env bash
set -euo pipefail

set_menubar_autohide() {
    local mode="$1"       # "Always" or "Never"
    local key="${mode:0:1}" # "A" or "N" — first letter to type in the popup

    osascript -e 'tell application "System Settings" to quit' 2>/dev/null
    sleep 1
    open "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension"
    sleep 3
    osascript -e "
        tell application \"System Events\"
            tell process \"System Settings\"
                set frontmost to true
                -- wait up to 10s for the popup to appear
                set targetPopup to missing value
                repeat 20 times
                    try
                        set targetPopup to pop up button \"Automatically hide and show the menu bar\" of group 1 of scroll area 1 of group 1 of group 3 of splitter group 1 of group 1 of window 1
                        exit repeat
                    end try
                    delay 0.5
                end repeat
                if targetPopup is missing value then error \"Menu bar popup not found\"
                perform action \"AXPress\" of targetPopup
                delay 0.5
                keystroke \"$key\"
                delay 0.2
                keystroke return
            end tell
        end tell
    "
    sleep 0.5
    osascript -e 'tell application "System Settings" to quit'
}

if pgrep -x yabai > /dev/null 2>&1; then
    echo "Stopping Slava modus..."

    echo "  Stopping yabai..."
    yabai --stop-service

    echo "  Stopping skhd..."
    skhd --stop-service

    echo "  Stopping sketchybar..."
    brew services stop sketchybar

    # echo "  Showing menu bar..."
    # set_menubar_autohide "Never"

    echo "Slava modus OFF"
else
    echo "Starting Slava modus..."

    # echo "  Auto-hiding menu bar..."
    # set_menubar_autohide "Always"

    echo "  Starting yabai..."
    yabai --start-service

    echo "  Starting skhd..."
    skhd --start-service

    echo "  Loading yabai scripting addition..."
    sudo yabai --load-sa

    echo "  Starting sketchybar..."
    brew services start sketchybar

    echo "Slava modus ON"
fi
