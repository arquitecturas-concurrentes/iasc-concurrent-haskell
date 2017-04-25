import Control.Concurrent
import Control.Exception as E

main = do
  lock <- newEmptyMVar
  forkIO $ do r <- try (takeMVar lock); print (r :: Either SomeException ())
  threadDelay 1000000
  print (lock == lock)
