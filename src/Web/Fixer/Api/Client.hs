{-# LANGUAGE OverloadedStrings #-}

module Web.Fixer.Api.Client (getGbpRates) where

import Network.Wreq (Response, Options, getWith, defaults, param, responseBody)
import Data.Text
import Data.Aeson.Lens (key, _Object)
import Data.Aeson.Types (Object)
import Control.Lens
import Control.Monad
import Data.ByteString.Lazy (ByteString)

getBaseFixerUrl :: String
getBaseFixerUrl = "http://api.fixer.io/latest"

gbpAsBaseCurrency :: Options
gbpAsBaseCurrency = getOpts "base" ["GBP"]

getOpts :: Text -> [Text] -> Options
getOpts key values = defaults & param key .~ values 

getGbpRates :: IO Object
getGbpRates = do
  response <- getWith gbpAsBaseCurrency getBaseFixerUrl
  return $ (parseRatesFromResponseBody . getResponseBody) response

parseRatesFromResponseBody :: ByteString -> Object
parseRatesFromResponseBody r = r ^. key "rates" . _Object

getResponseBody :: Response ByteString -> ByteString
getResponseBody r = r ^. responseBody
