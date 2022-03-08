# Honor per-interactive-shell startup file
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

source $HOME/.profile
# Add packages installed by Nix to path
# source $HOME/.nix-profile/etc/profile.d/nix.sh

# Exports
export PATH="$PATH:$HOME/.local/bin"
export QT_QPA_PLATFORMTHEME="qt5ct"
export XDG_DATA_DIRS="$XDG_DATA_DIRS\
:$HOME/.local/share/themes\
:$HOME/.local/share/icons"

if [ "$XDG_SESSION_TYPE" == wayland ]; then
    export MOZ_ENABLE_WAYLAND=1
    export WAYLAND_DISPLAY
    export XDG_CURRENT_DESKTOP=sway
fi
