{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}


module Web.Fixer.Api.Client (getGbpRates, MonadHTTP(..)) where

import Web.MonadHttp
import qualified Network.Wreq as W (Response, Options, getWith, defaults, param, responseBody, responseStatus, statusCode)
import Data.Text
import Data.Aeson.Lens (key, _Object)
import Data.Aeson.Types (Object)
import Control.Lens
import Control.Monad
import qualified Control.Exception as E 
import Control.Monad.Except
import Data.ByteString.Lazy (ByteString)

instance MonadHTTP (ExceptT Text IO) where
  getWith opts url = do 
    response <- liftIO $ W.getWith opts url
    case getStatus response of 
      200 -> return response
      _   -> throwError "ruhroh"

getStatus :: W.Response ByteString -> Int
getStatus r = r ^. W.responseStatus . W.statusCode 

getGbpRates :: (MonadError e m, MonadHTTP m) => ExceptT Text m (W.Response ByteString)
getGbpRates = getWith gbpAsBaseCurrency getBaseFixerUrl

getBaseFixerUrl :: String
getBaseFixerUrl = "http://api.fixer.io/latest"

gbpAsBaseCurrency :: W.Options
gbpAsBaseCurrency = getOpts "base" ["GBP"]

getOpts :: Text -> [Text] -> W.Options
getOpts key values = W.defaults & W.param key .~ values 

getResponseBody :: W.Response ByteString -> ByteString
getResponseBody r = r ^. W.responseBody

parseRatesFromResponseBody :: W.Response ByteString -> Object
parseRatesFromResponseBody r = r ^. W.responseBody . key "rates" . _Object