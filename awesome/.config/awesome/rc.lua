-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Collision for working with floating windows
require("collision")()

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Module loader
function loadrc(name, mod)
   local success
   local result

  -- Which file? In rc/ or in lib/?
  local path = awful.util.getdir("config") ..
  (mod and "lib" or "rc") ..
  "/" .. name .. ".lua"

 -- If the module is already loaded, don't load it again
 if mod and package.loaded[mod] then return package.loaded[mod] end

 -- Execute the RC/module file
 success, result = pcall(function() return dofile(path) end)
   if not success then
      naughty.notify({ title = "Error while loading an RC file",
       text = "When loading `" .. name ..
    "`, got the following error:\n" .. result,
           preset = naughty.config.presets.critical
         })
      return print("E: error loading RC file '" .. name .. "': " .. result)
   end

   -- Is it a module?
   if mod then
      return package.loaded[mod]
   end

   return result
end
-- }}}
-- You would just call:
-- loadrc("myWidgets")

-- Load config parts
loadrc("variables")
loadrc("menu")
loadrc("wibar")
loadrc("keybindings")
loadrc("rules")
loadrc("signals")
loadrc("autorun")
