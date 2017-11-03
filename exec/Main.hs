{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Control.Monad.Except (catchError)
import Control.Monad.IO.Class
import Web.Fixer.Api.Client
import Data.Text.Lazy
import Network.HTTP.Types

server :: ScottyM ()
server = get "/gbp" retreiveGbpRates

retreiveGbpRates :: ActionM ()
retreiveGbpRates = do 
    response <- liftAndCatchIO getGbpRates
    json response

main :: IO ()
main = scotty 3000 server