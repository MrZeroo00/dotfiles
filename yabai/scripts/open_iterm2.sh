#!/usr/bin/env bash

# Detects if iTerm2 is running
if ! pgrep -f "iTerm" > /dev/null; then
    open -a "/Applications/iTerm.app"
else
    :
fi
