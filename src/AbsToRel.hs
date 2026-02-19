module AbsToRel (
    abs2rel,
    stdin2line,
    Converter,
    base2converter,
    converted2stdout,
    start,
    args2arg,
    getBase,
    getBaseOrDefault,
) where

import System.Environment (getArgs)
import System.FilePath (makeRelative)
import System.IO (isEOF)

type BasePath = FilePath
type AbslPath = FilePath

abs2rel :: BasePath -> AbslPath -> FilePath
abs2rel = makeRelative

stdin2opt :: IO (Maybe String)
stdin2opt = do
    line :: String <- getLine
    return (Just line)

stdin2line :: IO (Maybe String)
stdin2line = do
    endOfFile :: Bool <- isEOF
    if endOfFile
        then return Nothing
        else stdin2opt

type Converter = AbslPath -> FilePath

base2converter :: BasePath -> Converter
base2converter = abs2rel

converted2stdout :: FilePath -> IO ()
converted2stdout = putStrLn

loop :: Converter -> Maybe String -> IO ()
loop _ Nothing = return ()
loop converter (Just line) = do
    let converted :: String = converter line
    converted2stdout converted
    next :: (Maybe String) <- stdin2line
    loop converter next

start :: BasePath -> IO ()
start base = do
    let converter :: Converter = base2converter base
    first :: (Maybe String) <- stdin2line
    loop converter first

args2arg :: [String] -> Maybe String
args2arg [arg1st] = Just arg1st
args2arg _ = Nothing

getArg :: IO (Maybe String)
getArg = do
    args :: [String] <- getArgs
    let oarg :: Maybe String = args2arg args
    return oarg

getBase :: IO (Maybe String)
getBase = getArg

baseOrDefault :: Maybe String -> String
baseOrDefault Nothing = "."
baseOrDefault (Just base) = base

getBaseOrDefault :: IO String
getBaseOrDefault = do
    obase :: Maybe String <- getBase
    let base :: String = baseOrDefault obase
    return base
