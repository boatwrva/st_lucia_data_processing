
#!/usr/bin/env python

## written by quick_adcp.py-- edit as needed:






# docs
# call from "cal/watertrk" subdirectory

from pycurrents.adcp.quick_npy import Guess_Xducerxy

# initialize
GuessXY = Guess_Xducerxy(dbname='a_sp',
                         fixfilexy='a_sp.gps')

# call
GuessXY()



