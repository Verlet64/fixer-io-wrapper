{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty (ScottyM, get, json, scotty, text, raw)
import Control.Monad.Except (ExceptT, lift, runExceptT)
import Control.Monad.IO.Class
import Web.Fixer.Api.Client
import Data.Text.Lazy

server :: ScottyM ()
server = get "/gbp" $ do
            response <- lift $ getGbpRates
            raw response
            -- case response of 
            --     Right currencyData -> json currencyData
            --     Left e -> (text . pack . show) e 

main :: IO ()
main = scotty 3000 server