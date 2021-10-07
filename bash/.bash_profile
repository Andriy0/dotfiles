# Honor per-interactive-shell startup file
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

# Activate profiles from .guix-extra-profiles
GUIX_EXTRA_PROFILES=$HOME/.guix-extra-profiles
for i in $GUIX_EXTRA_PROFILES/*; do
	profile=$i/$(basename "$i")
	if [ -f "$profile"/etc/profile ]; then
		GUIX_PROFILE="$profile"
		. "$GUIX_PROFILE"/etc/profile
	fi
	unset profile
done

# Add packages installed by Nix to path
. $HOME/.nix-profile/etc/profile.d/nix.sh

# Exports
export PATH="$PATH:$HOME/.local/bin"
# export QT_QPA_PLATFORMTHEME="qt5ct"
export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

if [ "$XDG_SESSION_TYPE" == wayland ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

# Start user instance of shepherd
if [[ ! -S ${XDG_RUNTIME_DIR-$HOME/.cache}/shepherd/socket ]]; then
    shepherd
fi
