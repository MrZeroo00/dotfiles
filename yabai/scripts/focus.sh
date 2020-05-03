#! /usr/bin/env zsh

echo "starting focus.sh"
    yabai -m window --focus mouse 2>/dev/null || true
echo "ending focus.sh"
