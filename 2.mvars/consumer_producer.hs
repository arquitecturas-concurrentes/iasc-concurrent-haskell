type CVar a = (MVar a, -- Producer -> consumer
MVar ()) -- Consumer -> producer
newCVar :: IO (CVar a)
newCVar
  = newMVar >>= \ data_var ->
    newMVar >>= \ ack_var ->
    putMVar ack_var ()  >>
    return (data_var, ack_var)

putCVar :: CVar a -> a -> IO ()
putCVar (data_var,ack_var) val
  = takeMVar ack_var >>
  putMVar data_var val

getCVar :: CVar a -> IO a
getCVar (data_var,ack_var)
  = takeMVar data_var
  putMVar ack_var ()
  return val  >>= \ val ->
