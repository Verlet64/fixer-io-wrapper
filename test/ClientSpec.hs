{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module ClientSpec (main, spec) where
    
import Test.Hspec
import Control.Monad.Reader
import Web.Fixer.Api.Client 
import Network.Wreq (Response)
import Data.ByteString.Lazy (ByteString)
import Network.HTTP.Types
import Network.HTTP.Client.Internal

succeededResponse :: Response ByteString
succeededResponse = Response { 
    responseStatus = mkStatus 200 "success"
  , responseVersion = http11
  , responseHeaders = []
  , responseBody = "{\"data\":\"some body\"}"
  , responseCookieJar = createCookieJar []
  , responseClose' = ResponseClose (return () :: IO ())
}

instance MonadHTTP (Reader (Response ByteString)) where
    getWith _ _ = ask

main :: IO ()
main = hspec spec

spec :: Spec
spec = describe "Hello" $ do
        it "World" $ do
            let rates = runReader getGbpRates succeededResponse
            rates `shouldBe` "{\"data\":\"some body\"}"