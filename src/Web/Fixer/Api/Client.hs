{-# LANGUAGE OverloadedStrings #-}

module Web.Fixer.Api.Client (getGbpRates, MonadHTTP(..)) where

import Web.MonadHttp
import qualified Network.Wreq as W (Response, Options, defaults, param, responseBody, responseStatus, statusCode)
import Data.Text
import Data.Aeson.Lens (key, _Object)
import Data.Aeson.Types (Object)
import Control.Lens
import Control.Monad
import Control.Monad.Except (ExceptT, liftIO, throwError)
import Data.ByteString.Lazy (ByteString)

getGbpRates :: MonadHTTP m => m ByteString
getGbpRates = do 
          response <- getWith gbpAsBaseCurrency getBaseFixerUrl
          return $ getResponseBody response

getBaseFixerUrl :: String
getBaseFixerUrl = "http://api.fixer.io/latest"

gbpAsBaseCurrency :: W.Options
gbpAsBaseCurrency = getOpts "base" ["GBP"]

getOpts :: Text -> [Text] -> W.Options
getOpts key values = W.defaults & W.param key .~ values 

getResponseBody :: W.Response ByteString -> ByteString
getResponseBody r = r ^. W.responseBody


-- getGbpRates :: FixerResponse
-- getGbpRates = do
--   response <- liftIO $ getWith gbpAsBaseCurrency getBaseFixerUrl
--   case response ^. responseStatus . statusCode of 
--     200 -> return $ (parseRatesFromResponseBody . getResponseBody) response
--     _   -> throwError "Failed to retreive currency data"

-- parseRatesFromResponseBody :: ByteString -> Object
-- parseRatesFromResponseBody r = r ^. key "rates" . _Object
