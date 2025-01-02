module Volume (increase, decrease) where

import Nix qualified

increase :: Int -> String
increase x = notify $ Nix.ponymix <> " increase " <> show x

decrease :: Int -> String
decrease x = notify $ Nix.ponymix <> " decrease " <> show x

notify :: String -> String
notify cmd = Nix.notify <> " \"Volume\" -h string:wired-tag:volume -t 3000 -h int:value:`" <> cmd <> "`"
