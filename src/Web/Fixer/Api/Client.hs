{-# LANGUAGE OverloadedStrings #-}

module Web.Fixer.Api.Client (getGbpRates, CurrencyData) where

import Network.Wreq (Response, Options, getWith, defaults, param, responseBody, responseStatus, statusCode)
import Data.Text
import Data.Aeson.Lens (key, _Object)
import Data.Aeson.Types (Object)
import Control.Lens
import Control.Monad
import Control.Monad.Except (ExceptT, liftIO, throwError)
import Data.ByteString.Lazy (ByteString)

type CurrencyData = Object
type FixerResponse = ExceptT Text IO Object

getBaseFixerUrl :: String
getBaseFixerUrl = "http://api.fixer.io/latest"

gbpAsBaseCurrency :: Options
gbpAsBaseCurrency = getOpts "base" ["GBP"]

getOpts :: Text -> [Text] -> Options
getOpts key values = defaults & param key .~ values 

getGbpRates :: FixerResponse
getGbpRates = do
  response <- liftIO $ getWith gbpAsBaseCurrency getBaseFixerUrl
  case response ^. responseStatus . statusCode of 
    200 -> return $ (parseRatesFromResponseBody . getResponseBody) response
    _   -> throwError "Failed to retreive currency data"

parseRatesFromResponseBody :: ByteString -> Object
parseRatesFromResponseBody r = r ^. key "rates" . _Object

getResponseBody :: Response ByteString -> ByteString
getResponseBody r = r ^. responseBody
