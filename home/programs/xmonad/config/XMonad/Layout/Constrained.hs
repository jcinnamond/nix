{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module XMonad.Layout.Constrained (
    Constrained (..),
)
where

import XMonad (LayoutClass (..), Rectangle (..))
import qualified XMonad.StackSet as S

data Constrained a = Constrained
    deriving (Show, Read)

instance LayoutClass Constrained a where
    pureLayout Constrained r s = constrainedLayout r (S.integrate s)

constrainedLayout :: Rectangle -> [a] -> [(a, Rectangle)]
constrainedLayout _ [] = []
constrainedLayout r (w : _) = [(w, center r)]

center :: Rectangle -> Rectangle
center (Rectangle x y w h) =
    let w' = round $ fromIntegral w * 0.7
        h' = round $ fromIntegral h * 0.9
        x' = x + fromIntegral (w - w') `div` 2
        y' = y + fromIntegral (h - h') `div` 2
     in Rectangle x' y' w' h'
