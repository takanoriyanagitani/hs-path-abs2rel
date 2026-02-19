module Main (main) where

import AbsToRel (getBaseOrDefault, start)

main :: IO ()
main = do
    baseOrDefault :: String <- getBaseOrDefault
    start baseOrDefault
