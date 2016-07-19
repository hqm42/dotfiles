import XMonad
import XMonad.Core
 
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Man
 
import XMonad.Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
 
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import qualified XMonad.StackSet as W
 
import XMonad.Util.EZConfig
import XMonad.Util.Run
import Graphics.X11.Xlib
import qualified Data.Map as M
import System.IO
 
-- main = xmonad defaultConfig

main = do
   myStatusBarPipe <- spawnPipe myStatusBar
   conkyBar <- spawnPipe myConkyBar
   trayer <- spawnPipe myTrayer
   xmonad $ myUrgencyHook $ defaultConfig
      { normalBorderColor  = myInactiveBorderColor
      , focusedBorderColor = myActiveBorderColor
      , terminal = "gnome-terminal"
      , manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
      , layoutHook = avoidStruts $ myLayoutHook
      , startupHook = setWMName "LG3D"
      , logHook = dynamicLogWithPP $ myDzenPP myStatusBarPipe
      , modMask = mod4Mask
      , keys = myKeys
     }
 
-- Font
myFont = "-*-terminus-*-*-*-*-12-*-*-*-*-*-iso8859-*"
 
-- Colors
myBgBgColor = "black"
myFgColor = "gray80"
myBgColor = "gray20"
myHighlightedFgColor = "white"
myHighlightedBgColor = "gray40"
 
myActiveBorderColor = "gray80"
myInactiveBorderColor = "gray20"
 
myCurrentWsFgColor = "white"
myCurrentWsBgColor = "gray40"
myVisibleWsFgColor = "gray80"
myVisibleWsBgColor = "gray20"
myHiddenWsFgColor = "gray80"
myHiddenEmptyWsFgColor = "gray50"
myUrgentWsBgColor = "brown"
myTitleFgColor = "white"
 
myUrgencyHintFgColor = "white"
myUrgencyHintBgColor = "brown"
 
-- dzen general options
myDzenGenOpts = "-fg '" ++ myFgColor ++ "' -bg '" ++ myBgColor ++ "' -fn '" ++ myFont ++ "' -h '" ++ (show barHeight) ++ "'"

myScreenWidth = 1920
barHeight = 16
traySpaces = 10
conkyWidth = 1200
trayerWidth = traySpaces * (barHeight + 3) + 2
statusWidth = myScreenWidth - conkyWidth - trayerWidth

-- Status Bar
myStatusBar = "dzen2 -w " ++ (show statusWidth) ++ " -ta l " ++ myDzenGenOpts
 
-- Conky Bar
myConkyBar = "conky -c ~/.conky_bar | dzen2 -x " ++ (show statusWidth) ++ " -w " ++ (show conkyWidth) ++ " " ++ myDzenGenOpts

-- My System Tray
myTrayer = "trayer --edge top --align right --SetDockType true --SetPartialStrut true " ++
  "--expand true --width " ++ (show traySpaces) ++ " --transparent true --alpha 0 --tint 0x333333 --height " ++ (show barHeight)
 
-- Layouts
myLayoutHook = smartBorders $ (Full ||| tiled ||| Mirror tiled)
  where
    tiled = ResizableTall nmaster delta ratio []
    nmaster = 1
    delta = 3/100
    ratio = 1/2
 
-- Urgency hint configuration
myUrgencyHook = withUrgencyHook dzenUrgencyHook
    {
      args = [
         "-x", "0", "-y", "576", "-h", "15", "-w", "1024",
         "-ta", "r",
         "-fg", "" ++ myUrgencyHintFgColor ++ "",
         "-bg", "" ++ myUrgencyHintBgColor ++ ""
         ]
    }
 
myManageHook = composeAll
   [ className =? "Gimp" --> doFloat
   , className =? "trayer" --> doFloat
   ]
 
-- Prompt config
myXPConfig = defaultXPConfig {
  position = Bottom,
  promptBorderWidth = 0,
  height = 15,
  bgColor = myBgColor,
  fgColor = myFgColor,
  fgHLight = myHighlightedFgColor,
  bgHLight = myHighlightedBgColor
  }
 
-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)
 
-- Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) = [
  -- Use shellPrompt instead of default dmenu
  ((modm, xK_p), shellPrompt myXPConfig),
  -- Do not leave useless conky and dzen after restart
  ((modm, xK_q), spawn "pkill -x conky; pkill -x dzen2; pkill -x trayer; xmonad --recompile; xmonad --restart"),
  ((modm, xK_l), spawn "slock"),
  ((modm, xK_Return), windows W.swapMaster)
   ]
 
-- Dzen config
myDzenPP h = defaultPP {
  ppOutput = hPutStrLn h,
  ppSep = "^bg(" ++ myBgBgColor ++ ")^r(1,15)^bg()",
  ppWsSep = "",
  ppCurrent = wrapFgBg myCurrentWsFgColor myCurrentWsBgColor,
  ppVisible = wrapFgBg myVisibleWsFgColor myVisibleWsBgColor,
  ppHidden = wrapFg myHiddenWsFgColor,
  ppHiddenNoWindows = wrapFg myHiddenEmptyWsFgColor,
  ppUrgent = wrapBg myUrgentWsBgColor,
  ppTitle = (\x -> " " ++ wrapFg myTitleFgColor x),
  ppLayout  = dzenColor myFgColor"" 
  }
  where
    wrapFgBg fgColor bgColor content= wrap ("^fg(" ++ fgColor ++ ")^bg(" ++ bgColor ++ ")") "^fg()^bg()" content
    wrapFg color content = wrap ("^fg(" ++ color ++ ")") "^fg()" content
    wrapBg color content = wrap ("^bg(" ++ color ++ ")") "^bg()" content
