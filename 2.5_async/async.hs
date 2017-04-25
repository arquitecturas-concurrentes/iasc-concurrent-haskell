import Control.Concurrent
import Data.ByteString as B
import GetURL

data Async a = Async (MVar a)
-- data Async a = Async ThreadId (MVar (Either SomeException a))

async :: IO a -> IO (Async a)
async action = do
  var <- newEmptyMVar
  forkIO (do r <- action; putMVar var r)
  return (Async var)

wait :: Async a -> IO a
wait (Async var) = readMVar var

main = do
  a1 <- async (getURL "http://www.wikipedia.org/wiki/A")
  a2 <- async (getURL "http://www.wikipedia.org/wiki/B")
  r1 <- wait a1
  r2 <- wait a2
  print (B.length r1, B.length r2)
