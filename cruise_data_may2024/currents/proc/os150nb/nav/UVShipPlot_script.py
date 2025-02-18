
#!/usr/bin/env python

## written by quick_mplplots.py -- edit as needed:

## cruiseid      is 'ADCP'
## dbname        is 'a_sp'
## proc_yearbase is 2024
## printformats   is 'png'

import matplotlib.pyplot as plt




from pycurrents.adcp.quick_mpl import UVShipPlot

PUV = UVShipPlot()
PUV(uvshipfile='a_sp.uvship',
   titlestr = 'ADCP: uvship diffs',
   proc_yearbase = 2024,
   printformats = 'png',
   ddrange = None)

plt.show()
