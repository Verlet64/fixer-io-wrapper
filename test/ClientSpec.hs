{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module ClientSpec (main, spec) where
    
import Test.Hspec
import Control.Monad.Reader
import Web.Fixer.Api.Client 
import Web.MonadHttp
import Network.Wreq (Response)
import Data.ByteString.Lazy (ByteString)
import Network.HTTP.Types
import Network.HTTP.Client.Internal
import Data.Text

succeededResponse :: Response ByteString
succeededResponse = Response { 
    responseStatus = mkStatus 200 "success"
  , responseVersion = http11
  , responseHeaders = []
  , responseBody = "{\"base\":\"test\", \"rates\": {\"toTest\": 12}}"
  , responseCookieJar = createCookieJar []
  , responseClose' = ResponseClose (return () :: IO ())
}

succeededResponseAssertion = ConversionRate (pack "test") (pack "toTest") 12 :: ConversionRate

instance MonadHTTP (ReaderT (Response ByteString) IO) where
    getWith _ _ = ask

main :: IO ()
main = hspec spec

spec :: Spec
spec = describe "getGbpRates" $ do
        it "Should make an API request and return a list of conversion rates for GBP, when the Fixer servers are up" $
            runReaderT getGbpRates succeededResponse `shouldReturn` [succeededResponseAssertion]