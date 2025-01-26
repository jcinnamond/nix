{-# OPTIONS_GHC -Wno-missing-signatures #-}
module Main where

import Data.List (isPrefixOf)
import Data.Map qualified as M
import Nix qualified
import System.Exit (exitSuccess)
import Volume qualified
import XMonad (Button, ButtonMask, ChangeLayout (..), IncMasterN (..), KeyMask, KeySym, ManageHook, Query, Window, X, XConfig (..), button1, button3, className, composeAll, doF, doShift, focus, io, kill, mod1Mask, mod4Mask, mouseMoveWindow, mouseResizeWindow, noModMask, runQuery, sendMessage, shiftMask, spawn, stringToKeysym, title, windows, withFocused, xK_Escape, xK_F4, xK_Left, xK_Right, xK_Tab, xK_a, xK_comma, xK_e, xK_equal, xK_i, xK_l, xK_m, xK_n, xK_period, xK_q, xK_r, xK_s, xK_space, xK_z, xmonad, (-->), (.|.), (<+>), (=?), (|||), stringProperty)
import XMonad.Actions.CopyWindow (copyToAll)
import XMonad.Actions.PerWorkspaceKeys (bindOn)
import XMonad.Actions.WindowGo (raiseNext)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Layout (Tall (..))
import XMonad.Layout.BoringWindows (boringWindows, focusMaster, focusUp)
import XMonad.Layout.CenteredIfSingle (centeredIfSingle)
import XMonad.Layout.ComboP (Property (Role))
import XMonad.Layout.Grid (Grid (..))
import XMonad.Layout.LayoutBuilder (Predicate (..), absBox, layoutAll, layoutP, layoutR, relBox, layoutN)
import XMonad.Layout.Maximize (maximizeRestore, maximizeWithPadding)
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest (Simplest (..))
import XMonad.Layout.Spacing (Border (..), spacingRaw)
import XMonad.Layout.Tabbed (simpleTabbed)
import XMonad.Layout.ThreeColumns (ThreeCol (..))
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
        , title =? "Picture-in-Picture" --> doF copyToAll
        ]

myWorkspaces :: [String]
myWorkspaces = ["dev", "web", "streaming", "chat", "x", "music"]

myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys _ = M.fromList $ wmKeys <> workspaceKeys myWorkspaces

wmKeys :: [((KeyMask, KeySym), X ())]
wmKeys =
    [ -- Launchers
      ((mod4Mask, xK_space), spawn "rofi -show drun -show-icons")
    , -- Manage and navigate windows
      ((mod1Mask, xK_Tab), bindOn [("streaming", raiseNext isStreaming), ("", focusUp)])
    , ((mod4Mask, xK_equal), focusMaster)
    , ((mod4Mask, xK_comma), sendMessage (IncMasterN 1))
    , ((mod4Mask, xK_period), sendMessage (IncMasterN (-1)))
    , ((mod4Mask, xK_Left), windows W.swapDown)
    , ((mod4Mask, xK_Right), windows W.swapUp)
    , ((mod4Mask, xK_Escape), windows W.swapMaster)
    , ((mod4Mask, xK_m), withFocused (sendMessage . maximizeRestore))
    , ((mod1Mask, xK_F4), kill)
    , ((mod4Mask, xK_l), sendMessage NextLayout)
    , -- System control
      ((mod4Mask, xK_z), spawn "systemctl suspend")
    , ((mod4Mask .|. shiftMask, xK_q), io exitSuccess)
    , -- Multimedia keys
      ((noModMask, stringToKeysym "XF86AudioPlay"), spawn "playerctl play-pause")
    , ((noModMask, stringToKeysym "XF86AudioPrev"), spawn "playerctl previous")
    , ((noModMask, stringToKeysym "XF86AudioNext"), spawn "playerctl next")
    , ((noModMask, stringToKeysym "XF86AudioStop"), spawn "playerctl stop")
    , ((noModMask, stringToKeysym "XF86AudioRaiseVolume"), spawn $ Volume.increase 2)
    , ((noModMask, stringToKeysym "XF86AudioLowerVolume"), spawn $ Volume.decrease 2)
    , ((noModMask, stringToKeysym "XF86AudioMute"), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , -- Workspaces
      ((mod4Mask, xK_a), (windows . W.greedyView) "dev")
    , ((mod4Mask .|. shiftMask, xK_a), (windows . W.shift) "dev")
    ]

workspaceKeys :: [String] -> [((KeyMask, KeySym), X ())]
workspaceKeys ws =
    let
        homerow = [xK_a, xK_r, xK_s, xK_n, xK_e, xK_i]
     in
        [((mod4Mask, k), (windows . W.greedyView) w) | (k, w) <- zip homerow ws]
            <> [((mod4Mask .|. shiftMask, k), (windows . W.shift) w) | (k, w) <- zip homerow ws]

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
            ( centerSingle centerMain
                ||| centerSingle (Tall 1 (1 / 100) (1 / 2))
                ||| centerSingle video
            )
    spaceWindows = spacingRaw True (Border 0 0 0 0) False (Border 5 5 5 5) True

    centerSingle = centeredIfSingle 0.7 0.9

    streaming =
        let
            castingWidth = 1920
            castingHeight = 1080
            spareX = screenWidth - castingWidth
            colWidth = spareX `div` 2
            spareY = screenHeight - castingHeight
         in
            onWorkspace "streaming" $
                layoutP Streaming (absBox colWidth (spareY `div` 3) castingWidth castingHeight) Nothing Simplest $
                    layoutR 0.1 0.5 (absBox 0 0 colWidth screenHeight) Nothing simpleTabbed $
                        layoutAll (absBox (screenWidth - colWidth) 0 colWidth screenHeight) Grid

    centerMain = 
        let
            mainWidth = screenWidth `div` 2
            sideWidth = screenWidth `div` 4
        in
            (layoutN 1 (absBox sideWidth 0 mainWidth screenHeight) (Just $ relBox 0 0 1 1) Simplest) $
            (layoutR 0.1 0.5 (absBox (sideWidth + mainWidth) 0 sideWidth screenHeight) Nothing $ Tall 1 (1/100) (1/2)) $
            layoutAll (absBox 0 0 sideWidth screenHeight) $ Tall 0 (1/100) (1/2)

    video =
        let
            videoWidth = 800
            videoHeight = 450
            videoX = screenWidth - videoWidth
            videoY = (screenHeight - videoHeight) `div` 5
         in
            layoutP (Role "PictureInPicture") (absBox videoX videoY videoWidth videoHeight) Nothing Simplest $
                layoutAll (absBox 10 0 2623 screenHeight) (Tall 1 (1 / 100) (1 / 2))

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
