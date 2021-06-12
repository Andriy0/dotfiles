-- http://projects.haskell.org/xmobar/
-- install xmobar with these flags: --flags="with_alsa" --flags="with_mpd" --flags="with_xft"  OR --flags="all_extensions"
-- you can find weather location codes here: http://weather.noaa.gov/index.html

Config { -- font    = "xft:Ubuntu:weight=bold:pixelsize=14:antialias=true:hinting=true"
         -- font =	    "xft:Mononoki Nerd Font Mono:weight=bold:size=13:antialias=true:hinting=true"
         font    = "xft:Fira Code Mono:weight=bold:pixelsize=17:antialias=true:hinting=true"
       , additionalFonts = [ "xft:Mononoki Nerd Font:pixelsize=13:antialias=true:hinting=true"
                           , "xft:Mononoki Nerd Font:pixelsize=16:antialias=true:hinting=true"
                           , "xft:FontAwesome:pixelsize=13"
                           ]
       , bgColor = "#282c34"
       , fgColor = "#ff6c6b"
       -- , position = Static { xpos = 0 , ypos = 0, width = 1920, height = 24 }
       , position = Top
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , iconRoot = "/home/andriy/.xmonad/xpm/"  -- default: "."
       , commands = [ 
                      -- Time and date
                      -- Run Date "<fn=2>\xf133</fn> %b %d %Y - (%H:%M)" "date" 50
                      Run Date "%b %d %Y - %H:%M" "date" 50
                      -- Network up and down
                    , Run Network "enp6s0" ["-t", "<fn=1>\xf0aa</fn> <rx>kb  <fn=1>\xf0ab</fn> <tx>kb"] 20
                      -- Cpu usage in percent
                    , Run Cpu ["-t", "<fn=1>\xf108</fn> cpu: (<total>%)","-H","50","--high","red"] 20
                      -- Ram used number and percent
                    , Run Memory ["-t", "<fn=1>\xf233</fn> mem: <used>M (<usedratio>%)"] 20
                      -- Disk space free
                    , Run DiskU [("/", "<fn=1>\xf0c7</fn> hdd: <free> free")] [] 60
                      -- Runs custom script to check for pacman updates.
                      -- This script is in my dotfiles repo in .local/bin.
                    , Run Com "/home/dt/.local/bin/pacupdate" [] "pacupdate" 36000
                      -- Runs a standard shell command 'uname -r' to get kernel version
                    , Run Com "uname" ["-r"] "" 3600
                      -- Battery status
                    , Run Battery [ "--template" , "<fc=#c792ea>Batt:</fc> <acstatus>"
                            , "--Low"      , "10"        -- units: %
                            , "--High"     , "80"        -- units: %
                            , "--low"      , "red"
                            , "--normal"   , "orange"
                            , "--high"     , "green"

                            , "--" -- battery specific options
                                      -- discharging status
                                      , "-o"	, "<left>% (<timeleft>)"
                                      -- AC "on" status
                                      , "-O"	, "<fc=#dAA520>Charging</fc>"
                                      -- charged status
                                      , "-i"	, "<fc=#98be65>Charged</fc>"
                            ] 50
                      -- Keyboard layout
                    , Run Kbd [ ("us(dvorak)" , "<fc=#00008B>dv</fc>")
                             , ("us"         , "<fc=#ffffff>us</fc>")
                             , ("ua"         , "<fc=#ffffff>ua</fc>")
                             ]
                      -- Prints out the left side items such as workspaces, layout, etc.
                      -- The workspaces are 'clickable' in my configs.
                    , Run UnsafeStdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " <action=`xdotool key control+alt+g`><icon=haskell_20.xpm/> </action><fc=#666666>|</fc> %UnsafeStdinReader% }{ %kbd% <fc=#666666><fn=2>|</fn> %battery% </fc><fc=#666666> <fn=2>|</fn></fc> <fc=#46d9ff> %date%  </fc>"
       }

