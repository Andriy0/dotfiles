#!/usr/bin/env bash

sed -n '/START_KEYS/,/END_KEYS/p' ~/.xmonad/xmonad.hs | \
    grep -e ', (' \
	 -e '\[ (' | \
    grep -v '\-\- , (' | \
    sed -e 's/^[ \t]*//' \
	-e 's/^, (/(/' \
	-e 's/^\[ (/(/' | \
    yad --text-info --back=#282c34 --fore=#46d9ff # --geometry=1200x600
