{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Web.Scotty as S
import Network.Wreq (Response, Options, getWith, defaults, param, responseBody)
import Data.Text
import Data.Aeson.Lens (key, _Array)
import Data.Aeson.Types (Array)
import Control.Lens
import Control.Monad
import Control.Monad.IO.Class
import Data.ByteString.Lazy (ByteString)

server :: S.ScottyM ()
server = do
    S.get "/gbp" $ do
        x <- liftIO getGbpRates
        S.raw x

main :: IO ()
main = do
    S.scotty 1234 server

getBaseFixerUrl :: String
getBaseFixerUrl = "http://api.fixer.io/latest"

gbpAsBaseCurrency :: Options
gbpAsBaseCurrency = getOpts "base" ["GBP"]

getOpts :: Text -> [Text] -> Options
getOpts key values = defaults & param key .~ values 

getGbpRates :: IO ByteString
getGbpRates = do
  response <- (getWith gbpAsBaseCurrency getBaseFixerUrl)
  return (getResponseBody response)

getResponseBody :: Response ByteString -> ByteString
getResponseBody r = r ^. responseBody
