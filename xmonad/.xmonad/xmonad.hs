-- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import System.Process (readProcess)
import Network.HostName
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (copyToAll, kill1, killAllOtherCopies)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat, doRectFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.ServerMode

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)

   -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont :: String
myFont = "xft:Mononoki Nerd Font:bold:size=13:antialias=true:hinting=true"

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String 
myBrowser = "firefox"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth   = 1

myModMask :: KeyMask
myModMask       = mod4Mask

myNormalBorderColor  = "#292d3e"
myFocusedBorderColor = "#bbc5ff"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mpv_term" spawnMpvTerm findMpvTerm manageTerm
                ]
  where
    spawnTerm  = myTerminal ++ " --class scratchpad"
    findTerm   = resource =? "scratchpad"
    spawnMpvTerm = myTerminal ++ " --class mpv_term"
    findMpvTerm = resource =? "mpv_term"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.5
                 t = 0.25
                 l = 0.25

mySharedProcesses :: [String]
mySharedProcesses = [ "xset r rate 300 50"
                    , "xsetroot -cursor_name left_ptr"
                    -- , "~/.fehbg"
                    , "nitrogen --restore"
                    , "picom --experimental-backends"
                    , "nm-applet"
                    , "pasystray"
                    , "stalonetray --geometry=-540+0 --background=#282c34"
                    , "dunst"
                    , "mpd"
                    , "mpDris2"
                    , "redshift"
                    -- , "xscreensaver -no-splash"
                    ]

myVoidProcesses :: [String]
myVoidProcesses = [ "doas guix-daemon --build-users-group=guixbuild --substitute-urls='https://mirror.brielmaier.net'"
                  , "emacs --daemon"
                  ]
  
myGuixProcesses :: [String]
myGuixProcesses = [ "xsettingsd"
                  ]

myProcesses :: String -> [String]
myProcesses hostname
    | hostname == "void" = mySharedProcesses ++ myVoidProcesses
    | hostname == "guixsd" = mySharedProcesses ++ myGuixProcesses
    | otherwise = mySharedProcesses

spawnMyProcesses :: [String] -> X ()
spawnMyProcesses [] = return ()
spawnMyProcesses (x:xs) = do
    spawnOnce x
    spawnMyProcesses xs

myStartupHook :: String -> X ()
myStartupHook hostname = do
    spawnMyProcesses $ myProcesses hostname
    setWMName "LG3D"

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
-- magnify  = renamed [Replace "magnify"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ magnifier
--            $ limitWindows 12
--            $ mySpacing 8
--            $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 simplestFloat
-- grid     = renamed [Replace "grid"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 12
--            $ mySpacing 8
--            $ mkToggle (single MIRROR)
--            $ Grid (16/10)
-- spirals  = renamed [Replace "spirals"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ mySpacing' 8
--            $ spiral (6/7)
-- threeCol = renamed [Replace "threeCol"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 7
--            $ mySpacing' 4
--            $ ThreeCol 1 (3/100) (1/2)
-- threeRow = renamed [Replace "threeRow"]
--            $ windowNavigation
--            $ addTabs shrinkText myTabTheme
--            $ subLayout [] (smartBorders Simplest)
--            $ limitWindows 7
--            $ mySpacing' 4
--            -- Mirror takes a layout and rotates it by 90 degrees.
--            -- So we are applying Mirror to the ThreeCol layout.
--            $ Mirror
--            $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme

myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout =     tall
                                --  ||| magnify
                                 ||| noBorders monocle
                                --  ||| floats
                                 ||| noBorders tabs
                                --  ||| grid
                                --  ||| spirals
                                --  ||| threeCol
                                --  ||| threeRow

myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myClickableWorkspaces :: [String]
myClickableWorkspaces = clickable . (map xmobarEscape)
               $ [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
              --  $ [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ title =? "Mozilla Firefox" --> doShift ( myClickableWorkspaces !! 1 )
    , className =? "Chromium" --> doShift ( myClickableWorkspaces !! 1 )
    , className =? "Code - OSS" --> doShift ( myClickableWorkspaces !! 2 )
    , className =? "TelegramDesktop" --> doShift ( myClickableWorkspaces !! 3 )
    , className =? "GoldenDict" --> doShift ( myClickableWorkspaces !! 4 )
    , className =? "qutebrowser" --> doShift ( myClickableWorkspaces !! 1 )
    , className =? "MPlayer" --> doFloat
    , resource  =? "Toolkit" --> doFloat -- for Firefox
    , title =? "Picture in picture" --> doFloat -- for Chromium
    , className =? "Gscreenshot" --> doFloat
    , className =? "Virt-manager" --> doFloat
    , className =? "Nitrogen" --> doFloat
    , className =? "Lxappearance" --> doFloat
    , className =? "Blueman-manager" --> doFloat
    , className =? "Nm-connection-editor" --> doFloat
    , className =? "Blueman-services" --> doFloat
    , className =? "qt5ct" --> doFloat
    , className =? "Kvantum Manager" --> doFloat
    , className =? "Ristretto" --> doFloat
    , className =? "Qalculate-gtk" --> doFloat
    , className =? "Yad" --> doRectFloat (W.RationalRect 0.25 0.25 0.5 0.5)
    , resource =? "float_term" --> doFloat
    , resource =? "desktop_window" --> doIgnore
    , resource =? "kdesktop" --> doIgnore 
    , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
    , className =? "jetbrains-studio" --> doFloat
    , title =? "Emulator" --> doFloat
    ] <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------------------------
-- External commands
myCommands :: [(String, X ())]
myCommands =
        [ ("decrease-master-size"      , sendMessage Shrink                               )
        , ("increase-master-size"      , sendMessage Expand                               )
        , ("decrease-master-count"     , sendMessage $ IncMasterN (-1)                    )
        , ("increase-master-count"     , sendMessage $ IncMasterN ( 1)                    )
        , ("focus-prev"                , windows W.focusUp                                )
        , ("focus-next"                , windows W.focusDown                              )
        , ("focus-master"              , windows W.focusMaster                            )
        , ("swap-with-prev"            , windows W.swapUp                                 )
        , ("swap-with-next"            , windows W.swapDown                               )
        , ("swap-with-master"          , windows W.swapMaster                             )
        , ("toggle-noborder-full"      , sendMessage (MT.Toggle NBFULL) >>
                                         sendMessage ToggleStruts                         )
        , ("kill-window"               , kill                                             )
        , ("quit"                      , io exitSuccess                                   )
        , ("restart"                   , spawn "xmonad --recompile; xmonad --restart"     )
        ]

-----------------------------------------------------------------------
-- Custom server mode
myServerModeEventHook = serverModeEventHookCmd' $ return myCommands'
myCommands' = ("list-commands", listMyServerCmds) : myCommands

listMyServerCmds :: X ()
listMyServerCmds = spawn ("echo '" ++ asmc ++ "' | yad --text-info")
    where asmc = concat $ "Available commands:\n" : map (\(x, _)-> "  " ++ x ++ "\n") myCommands'

-- START_KEYS
myKeys :: [(String, X ())]
myKeys = 
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile; xmonad --restart")
        , ("M-C-e", io exitSuccess)             -- Quits xmonad

    -- Kill windows
        , ("M-q", kill1)                         -- Kill the currently focused client
        , ("M-S-v", killAll)                       -- Kill all windows on current workspace

    -- Floating windows
        -- , ("M-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-C-<Up>", sendMessage Arrange)
        , ("M-C-<Down>", sendMessage DeArrange)
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-S-<Space>", sendMessage ToggleStruts)     -- Toggles struts
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)  -- Toggles noborder

    -- Launch some programs
        , ("M-<Return>", spawn myTerminal)
        -- , ("M-S-<Return>", spawn $ myTerminal ++ " --class float_term")
        -- , ("M-p", spawn "dmenu_run -fn 'Mononoki Nerd Font Bold Mono-13'") -- launch dmenu
        , ("M-p", spawn "rofi -show combi -modi combi")
        -- , ("M-x", spawn "betterlockscreen -l dimblur") -- lock screen
        , ("M-x", spawn "slock") -- lock screen
        , ("M-s", spawn "flameshot gui") -- flameshot
        , ("M-S-s", spawn "gscreenshot") -- gscreenshot
    
    -- Scratchpads
        , ("M-e", namedScratchpadAction myScratchPads "terminal")
        , ("M-r", namedScratchpadAction myScratchPads "mpv_term")

    -- Window Copying Bindings
        , ("M-a"            , windows copyToAll ) -- Pin to all workspaces
        , ("M-C-a"          , killAllOtherCopies) -- remove window from all but current
        , ("M-S-a"          , kill1             ) -- remove window from current, kill if only one

    -- Window navigation
        , ("M-j", windows W.focusDown) -- Move focus to the next window
        , ("M-k", windows W.focusUp) -- Move focus to the previous window  
        , ("M-m", windows W.focusMaster) -- Move focus to the master window        
        , ("M-S-<Return>", windows W.swapMaster) -- Swap the focused window and the master window        
        , ("M-S-j", windows W.swapDown) -- Swap the focused window with the next window        
        , ("M-S-k", windows W.swapUp) -- Swap the focused window with the previous window    
        , ("M-h", sendMessage Shrink) -- Shrink the master area        
        , ("M-l", sendMessage Expand) -- Expand the master area
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Volume Controls
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")

    -- Multimedia Controls 
        , ("M-<F2>", spawn "playerctl volume .1-")
        , ("M-<F3>", spawn "playerctl volume .1+")
        , ("M-<F5>", spawn "playerctl stop")
        , ("M-<F6>", spawn "playerctl previous")
        , ("M-<F7>", spawn "playerctl play-pause")
        , ("M-<F8>", spawn "playerctl next")

    -- Brightness Controls
        , ("<XF86MonBrightnessUp>", spawn "light -A 1")
        , ("<XF86MonBrightnessDown>", spawn "light -U 1")

    -- Misc
        , ("M-,", sendMessage (IncMasterN 1)) -- Increment the number of windows in the master area
        , ("M-.", sendMessage (IncMasterN (-1))) -- Deincrement the number of windows in the master area
        , ("M-b", sendMessage ToggleStruts) -- Key binding to toggle the gap for the bar.
        -- , ("M-<Space>", sendMessage NextLayout) -- Rotate through the available layout algorithms
    ]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)) -- mod-button1, Set the window to floating mode and move by dragging
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster)) -- mod-button2, Raise the window to the top of the stack
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)) -- mod-button3, Set the window to floating mode and resize by dragging
    ]
-- END_KEYS

main :: IO ()
main = do 
    xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobar.hs"
    myHostName <- getHostName
    xmonad $ ewmh def
      -- simple stuff
        { terminal           = myTerminal
        , focusFollowsMouse  = myFocusFollowsMouse
        , clickJustFocuses   = myClickJustFocuses
        , borderWidth        = myBorderWidth
        , modMask            = myModMask
        , workspaces         = myClickableWorkspaces
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor

      -- key bindings
        , mouseBindings      = myMouseBindings

      -- hooks, layouts
        , layoutHook         = myLayoutHook
        , manageHook         = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook <+> fullscreenEventHook <+> myServerModeEventHook
        , startupHook        = myStartupHook myHostName
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]" -- Current workspace in xmobar
            , ppVisible = xmobarColor "#98be65" ""                -- Visible but not current workspace
            , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
            , ppHiddenNoWindows = xmobarColor "#c792ea" ""        -- Hidden workspaces (no windows)
            , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
            , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"          -- Separators in xmobar
            , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
            , ppExtras  = [windowCount]                           -- # of windows current workspace
            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
            }
    } `additionalKeysP` myKeys
