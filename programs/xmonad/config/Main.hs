{-# OPTIONS_GHC -Wno-missing-signatures #-}

module Main where

import Data.List (isPrefixOf)
import Data.Map qualified as M
import Nix qualified
import System.Exit (exitSuccess)
import Volume qualified
import XMonad (Button, ButtonMask, ChangeLayout (..), IncMasterN (..), KeyMask, KeySym, ManageHook, Query, Window, X, XConfig (..), button1, button3, className, composeAll, controlMask, doF, doShift, focus, io, kill, mod1Mask, mod4Mask, mouseMoveWindow, mouseResizeWindow, noModMask, runQuery, sendMessage, shiftMask, spawn, stringProperty, stringToKeysym, title, windows, withFocused, xK_Escape, xK_Left, xK_Right, xK_Tab, xK_a, xK_comma, xK_e, xK_equal, xK_i, xK_k, xK_l, xK_m, xK_n, xK_period, xK_q, xK_r, xK_s, xK_semicolon, xK_space, xK_t, xK_z, xmonad, (-->), (.|.), (<+>), (=?), (|||))
import XMonad.Actions.CopyWindow (copyToAll)
import XMonad.Actions.PerWorkspaceKeys (bindOn)
import XMonad.Actions.WindowGo (raiseNext)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Layout (Tall (..))
import XMonad.Layout.BoringWindows (boringWindows, focusMaster, focusUp)
import XMonad.Layout.CenteredIfSingle (centeredIfSingle)
import XMonad.Layout.ComboP (Property (..))
import XMonad.Layout.Grid (Grid (..))
import XMonad.Layout.LayoutBuilder (Predicate (..), absBox, layoutAll, layoutN, layoutP, layoutR, relBox)
import XMonad.Layout.Maximize (maximizeRestore, maximizeWithPadding)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest (Simplest (..))
import XMonad.Layout.Spacing (Border (..), spacingRaw)
import XMonad.Layout.Tabbed (simpleTabbed)
import XMonad.Layout.WindowNavigation (windowNavigation)
import XMonad.StackSet qualified as W

main :: IO ()
main = xmonad $ docks $ ewmh $ myConfig def

myConfig c =
  theme
    c
      { keys = myKeys
      , mouseBindings = myBindings
      , workspaces = myWorkspaces
      , layoutHook = myLayout
      , manageHook = myManageHook <+> manageHook def
      }

myManageHook :: ManageHook
myManageHook =
  composeAll
    [ isStreaming --> doShift "streaming"
    , className =? "Spotify" --> doShift "music"
    , className =? "YouTube Music Desktop App" --> doShift "music"
    , className =? "Signal" --> doShift "chat"
    , className =? "zoom" --> doShift "chat"
    , stringProperty "WM_WINDOW_ROLE" =? "browser" --> doShift "web"
    , title =? "Picture-in-Picture" --> doF copyToAll
    , title =? "Picture-in-picture" --> doF copyToAll
    ]

myWorkspaces :: [String]
myWorkspaces = ["dev", "web", "x", "chat", "y", "streaming", "music"]

myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys _ = M.fromList $ wmKeys <> workspaceKeys myWorkspaces

xmod :: KeyMask
xmod = mod4Mask .|. mod1Mask .|. controlMask

wmKeys :: [((KeyMask, KeySym), X ())]
wmKeys =
  [ -- Launchers
    ((xmod, xK_space), spawn "rofi -show drun -show-icons")
  , -- Manage and navigate windows
    ((mod1Mask, xK_Tab), bindOn [("streaming", raiseNext isStreaming), ("", focusUp)])
  , ((xmod, xK_equal), focusMaster)
  , ((xmod, xK_Left), windows W.swapUp)
  , ((xmod, xK_Right), windows W.swapDown)
  , ((xmod, xK_Escape), windows W.swapMaster)
  , ((xmod, xK_m), withFocused (sendMessage . maximizeRestore))
  , ((xmod, xK_t), withFocused $ windows . W.sink)
  , ((xmod, xK_k), kill)
  , ((xmod, xK_l), sendMessage NextLayout)
  , ((xmod, xK_period), windows W.swapMaster)
  , ((xmod, xK_comma), sendMessage (IncMasterN 1))
  , ((xmod, xK_semicolon), sendMessage (IncMasterN (-1)))
  , -- System control
    ((xmod, xK_z), spawn "systemctl suspend")
  , ((xmod .|. shiftMask, xK_q), io exitSuccess)
  , -- Multimedia keys
    ((noModMask, stringToKeysym "XF86AudioPlay"), spawn "playerctl play-pause")
  , ((noModMask, stringToKeysym "XF86AudioPrev"), spawn "playerctl previous")
  , ((noModMask, stringToKeysym "XF86AudioNext"), spawn "playerctl next")
  , ((noModMask, stringToKeysym "XF86AudioStop"), spawn "playerctl stop")
  , ((noModMask, stringToKeysym "XF86AudioRaiseVolume"), spawn $ Volume.increase 2)
  , ((noModMask, stringToKeysym "XF86AudioLowerVolume"), spawn $ Volume.decrease 2)
  , ((noModMask, stringToKeysym "XF86AudioMute"), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
  , -- Workspaces
    ((xmod, xK_a), (windows . W.greedyView) "dev")
  , ((xmod .|. shiftMask, xK_a), (windows . W.shift) "dev")
  ]

workspaceKeys :: [String] -> [((KeyMask, KeySym), X ())]
workspaceKeys ws =
  let homerow = [xK_a, xK_r, xK_s, xK_t, xK_n, xK_e, xK_i]
   in [((xmod, k), (windows . W.greedyView) w) | (k, w) <- zip homerow ws]
        <> [((xmod .|. shiftMask, k), (windows . W.shift) w) | (k, w) <- zip homerow ws]

myBindings :: XConfig l -> M.Map (ButtonMask, Button) (Window -> X ())
myBindings _ =
  M.fromList
    [ ((mod4Mask, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
    , ((mod4Mask, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
    ]

theme :: XConfig a -> XConfig a
theme config =
  config
    { borderWidth = 2
    , focusedBorderColor = Nix.focusedBorderColor
    , normalBorderColor = Nix.normalBorderColor
    }

myLayout = windowNavigation $ avoidStruts $ maximizeWithPadding 0 $ spaceWindows $ boringWindows layouts
 where
  layouts =
    streaming
      ( centerSingle (Tall 1 (1 / 10) (7 / 10))
          ||| centerSingle centerMain
          ||| centerSingle (Tall 1 (1 / 100) (1 / 2))
          ||| centerSingle (video (Tall 1 (1 / 100) (1 / 2)))
      )
  spaceWindows = spacingRaw True (Border 0 0 0 0) False (Border 5 5 5 5) True

  centerSingle = centeredIfSingle 0.7 0.9

  streaming =
    let castingWidth = 1920
        castingHeight = 1080
        spareX = screenWidth - castingWidth
        colWidth = spareX `div` 2
        spareY = screenHeight - castingHeight
     in onWorkspace "streaming" $
          layoutP Streaming (absBox colWidth (spareY `div` 3) castingWidth castingHeight) Nothing Simplest $
            layoutR 0.1 0.5 (absBox 0 0 colWidth screenHeight) Nothing simpleTabbed $
              layoutAll (absBox (screenWidth - colWidth) 0 colWidth screenHeight) Grid

  centerMain =
    let mainWidth = screenWidth `div` 2
        sideWidth = screenWidth `div` 4
     in (layoutN 1 (absBox sideWidth 0 mainWidth screenHeight) (Just $ relBox 0 0 1 1) Simplest) $
          (layoutR 0.1 0.5 (absBox (sideWidth + mainWidth) 0 sideWidth screenHeight) Nothing $ Tall 1 (1 / 100) (1 / 2)) $
            layoutAll (absBox 0 0 sideWidth screenHeight) $
              Tall 0 (1 / 100) (1 / 2)

  video l =
    let videoWidth = 1200
        videoHeight = videoWidth `div` 16 * 9
        videoX = screenWidth - videoWidth
        videoY = (screenHeight - videoHeight) `div` 5
     in layoutP (Title "Picture-in-picture" `Or` Role "pop-up") (absBox videoX videoY videoWidth videoHeight) Nothing Simplest $
          layoutAll (absBox 0 0 (videoX - 5) screenHeight) l

  screenWidth = 3440
  screenHeight = 1440

isStreaming :: Query Bool
isStreaming = do
  cn <- className
  pure $ "streaming-" `isPrefixOf` cn

data Streaming = Streaming
  deriving (Show, Read)

instance Predicate Streaming Window where
  alwaysTrue _ = Streaming
  checkPredicate _ = runQuery isStreaming

role :: Query String
role = stringProperty "role"
