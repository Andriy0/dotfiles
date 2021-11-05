#!/usr/bin/env bash

if pidof waybar > /dev/null
then
    pkill waybar
    sleep 1
    exec waybar
else
    exec waybar
fi

