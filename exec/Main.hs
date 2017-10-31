{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty (ScottyM, get, json, scotty)
import Control.Monad.IO.Class
import Web.Fixer.Api.Client

server :: ScottyM ()
server = get "/gbp" $ do
            response <- liftIO getGbpRates
            json response

main :: IO ()
main = scotty 3000 server