
-- {{{ Autorun apps
-- A function to run apps once
local naughty   = require( "naughty" )
local awful     = { spawn = require( "awful.spawn" ) }
local string    = { sub = string.sub        ,
		    find = string.find      ,
		    format = string.format  }

-- This function makes sure the application is not restarted when awesome is reloaded
local function run_once( command )
   local args_start = string.find( command, " " )
   local pgrep_name = args_start and command:sub( 0, args_start - 1 ) or command

   local command = "pgrep -u $USER -x " .. pgrep_name .. " > /dev/null || (" .. command .. ")"

   awful.spawn.easy_async_with_shell(
      command,
      function( stdout, stderr, exitreason, exitcode )
	 if exitcode ~= 0 then
	    naughty.notify({
		  preset  = naughty.config.presets.critical           ,
		  text    = string.format(    "%s\n\n%s\n%s\n%s\n%s", 
					      command,
					      stdout,
					      stderr,
					      exitreason,
					      exitcode )              })
	 end
   end )
end

-- Apps to run
autorun = true
autorunApps = 
   {
      "xset r rate 300 50",
      "picom",
      -- "nitrogen --restore",
      "~/.fehbg",
      "xsetroot -cursor_name left_ptr",
      "xsettingsd",
      -- "pipewire",
      -- "pipewire-pulse",
      "nm-applet",
      "pasystray",
      -- "volumeicon",
      "mpd",
      "mpDris2",
      -- "emacs --daemon",
      "redshift",
      "xscreensaver -no-splash"
   }
if autorun then
   for app = 1, #autorunApps do
      run_once(autorunApps[app])
   end
end

-- Examples
-- run_once( "guake &> /dev/null" )
-- run_once( "remmina -i &> /dev/null" )
-- run_once( "skypeforlinux" )
-- }}}
