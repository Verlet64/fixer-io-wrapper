{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveGeneric #-}

module Web.Fixer.Api.Client where

import qualified Network.Wreq as W (Response, Options, getWith, defaults, param, responseBody, responseStatus, statusCode)
import Data.Text
import Data.Aeson
import Data.Aeson.Lens 
import Data.Aeson.Types
import Control.Lens
import Web.MonadHttp
import Control.Monad
import Control.Monad.IO.Class
import qualified Data.Map as M
import Control.Monad.Catch
import Control.Monad.Except
import Data.ByteString.Lazy (ByteString)
import GHC.Generics

type CurrValuePair = (Text, Double)

data HttpClientError = FailedToRetreive
instance Show HttpClientError where
  show FailedToRetreive = "Unable to retreive data for request"
instance Exception HttpClientError

data RawFixerResponse = RawFixerResponse {
  base :: Text
  , rates :: M.Map Text Double
} deriving (Show, Generic)
instance FromJSON RawFixerResponse
instance ToJSON RawFixerResponse

data ConversionRate = ConversionRate {
  fromCurrency :: Text
  , toCurrency :: Text
  , rate :: Double
} deriving (Show, Generic, Eq)
instance ToJSON ConversionRate

getGbpRates :: (MonadThrow m, MonadIO m, MonadHTTP m) => m [ConversionRate]
getGbpRates = do 
  response <- getWith gbpAsBaseCurrency getBaseFixerUrl
  case getResponseBody response of
    Just val -> return $ (getConversionRates (base val) (M.toList $ rates val))
    Nothing -> throwM FailedToRetreive
  
getBaseFixerUrl :: String
getBaseFixerUrl = "http://api.fixer.io/latest"

gbpAsBaseCurrency :: W.Options
gbpAsBaseCurrency = getOpts "base" ["GBP"]

getOpts :: Text -> [Text] -> W.Options
getOpts key values = W.defaults & W.param key .~ values 

getConversionRates :: Text -> [CurrValuePair] -> [ConversionRate]
getConversionRates baseCurrency conversionRates = Prelude.map (\x -> (ConversionRate baseCurrency) (fst x) (snd x)) conversionRates

getResponseBody :: W.Response ByteString -> Maybe RawFixerResponse
getResponseBody r = decode (r ^. W.responseBody) 
