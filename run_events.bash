#/bin/bash
ghc mvar4.hs -threaded -eventlog
./mvar4 +RTS -l
