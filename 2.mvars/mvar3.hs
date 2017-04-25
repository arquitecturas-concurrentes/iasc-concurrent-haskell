import Control.Concurrent

main = do
  m <- newEmptyMVar
  takeMVar m
