# Set the screen DPI (uncomment this if needed!)
# xrdb ~/.emacs.d/exwm/Xresources

# Run some commands
picom &
xsettingsd &
nitrogen --restore &
xset r rate 300 50 &
xsetroot -cursor_name left_ptr &
# pipewire &
# pipewire-pulse &
redshift &
nm-applet &
# volumeicon &
pasystray &
xscreensaver --no-splash &

# Enable screen locking on suspend
# xss-lock -- slock &

# Fire it up
xhost +SI:localuser:$USER
exec dbus-launch --exit-with-session emacs-28.0.50 -mm -l ~/.config/emacs/main-config/desktop.el
# exec dbus-launch --exit-with-session emacsclient --eval "(exwm-init)" -c -F '((fullscreen . fullboth))'
