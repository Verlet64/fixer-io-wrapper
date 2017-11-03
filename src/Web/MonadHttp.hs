{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

module Web.MonadHttp (MonadHTTP(..)) where 

import qualified Network.Wreq as W (Response, Options, getWith)
import Data.ByteString.Lazy (ByteString)
import Control.Monad.Reader

class Monad m => MonadHTTP m where 
    getWith ::  W.Options -> String -> m (W.Response ByteString)
instance MonadHTTP IO where
    getWith = W.getWith