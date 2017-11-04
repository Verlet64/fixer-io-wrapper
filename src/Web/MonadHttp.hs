{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}

module Web.MonadHttp (MonadHTTP(..), HttpClientError) where 

import qualified Network.Wreq as W (Response, Options, getWith, responseStatus, statusCode)
import Control.Monad.Except
import Control.Lens
import Data.Text
import qualified Control.Exception as E 
import Data.ByteString.Lazy (ByteString)


data HttpClientError = RetreivalError | ClientError 

class (MonadError Text m, Monad m) => MonadHTTP m where 
    getWith :: W.Options -> String -> m (W.Response ByteString)