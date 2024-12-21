{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# HLINT ignore "Move brackets to avoid $" #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Main where

import Colors (focusedColor, inactiveColor)
import Data.List (isPrefixOf)
import Data.Map qualified as M
import System.Exit (exitSuccess)
import XMonad (Button, ButtonMask, ChangeLayout (..), IncMasterN (..), KeyMask, KeySym, ManageHook, Query, Window, X, XConfig (..), button1, button3, className, composeAll, doF, doFloat, doShift, focus, io, kill, mod1Mask, mod4Mask, mouseMoveWindow, mouseResizeWindow, noModMask, runQuery, sendMessage, shiftMask, spawn, stringToKeysym, title, windows, withFocused, xK_Escape, xK_Left, xK_Right, xK_Tab, xK_a, xK_comma, xK_e, xK_equal, xK_i, xK_k, xK_l, xK_m, xK_n, xK_period, xK_q, xK_r, xK_s, xK_space, xK_z, xmonad, (-->), (.|.), (<+>), (=?), (|||))
import XMonad.Actions.CopyWindow (copyToAll)
import XMonad.Actions.PerWorkspaceKeys (bindOn)
import XMonad.Actions.WindowGo (raiseNext)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (avoidStruts, docks)
import XMonad.Layout (Tall (..))
import XMonad.Layout.BoringWindows (boringWindows, focusMaster, focusUp)
import XMonad.Layout.CenteredIfSingle (centeredIfSingle)
import XMonad.Layout.Grid (Grid (..))
import XMonad.Layout.LayoutBuilder (Predicate (..), absBox, layoutAll, layoutP, layoutR)
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
        , title =? "Picture-in-Picture" --> doFloat
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
    , ((mod4Mask .|. shiftMask, xK_k), kill)
    , ((mod4Mask, xK_l), sendMessage NextLayout)
    , -- System control
      ((mod4Mask, xK_z), spawn "systemctl suspend")
    , ((mod4Mask .|. shiftMask, xK_q), io exitSuccess)
    , -- Multimedia keys
      ((noModMask, stringToKeysym "XF86AudioPlay"), spawn "playerctl play-pause")
    , ((noModMask, stringToKeysym "XF86AudioPrev"), spawn "playerctl previous")
    , ((noModMask, stringToKeysym "XF86AudioNext"), spawn "playerctl next")
    , ((noModMask, stringToKeysym "XF86AudioStop"), spawn "playerctl stop")
    , ((noModMask, stringToKeysym "XF86AudioRaiseVolume"), spawn "pactl set-sink-volume @DEFAULT_SINK@ +2%")
    , ((noModMask, stringToKeysym "XF86AudioLowerVolume"), spawn "pactl set-sink-volume @DEFAULT_SINK@ -2%")
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
        , focusedBorderColor = focusedColor
        , normalBorderColor = inactiveColor
        }

myLayout = windowNavigation $ avoidStruts $ maximizeWithPadding 0 $ spaceWindows $ boringWindows layouts
  where
    layouts =
        onWorkspace "streaming" streaming $
            ( centeredIfSingle 0.7 0.9 (ThreeColMid 1 (1 / 100) (1 / 2))
                ||| centeredIfSingle 0.7 0.92 (Tall 1 (1 / 100) (1 / 2))
            )
    spaceWindows = spacingRaw True (Border 0 0 0 0) False (Border 5 5 5 5) True

    streaming =
        let
            castingWidth = 1920
            castingHeight = 1080
            screenWidth = 3440
            screenHeight = 1440
            spareX = screenWidth - castingWidth
            colWidth = spareX `div` 2
            spareY = screenHeight - castingHeight
         in
            layoutP Streaming (absBox colWidth (spareY `div` 3) castingWidth castingHeight) Nothing Simplest $
                layoutR 0.1 0.5 (absBox 0 0 colWidth screenHeight) Nothing simpleTabbed $
                    layoutAll (absBox (screenWidth - colWidth) 0 colWidth screenHeight) Grid

isStreaming :: Query Bool
isStreaming = do
    cn <- className
    pure $ "streaming-" `isPrefixOf` cn

data Streaming = Streaming
    deriving (Show, Read)
instance Predicate Streaming Window where
    alwaysTrue _ = Streaming
    checkPredicate _ = runQuery isStreaming
