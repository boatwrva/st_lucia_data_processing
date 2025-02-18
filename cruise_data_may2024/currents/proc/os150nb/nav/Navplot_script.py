
#!/usr/bin/env python

## written by quick_mplplots.py -- edit as needed:

## cruiseid      is 'ADCP'
## dbname        is 'a_sp'
## proc_yearbase is 2024
## printformats   is 'png'

import matplotlib.pyplot as plt





from pycurrents.adcp.quick_mpl import Navplot

PN = Navplot()
PN(dbname = 'a_sp',
   titlestr = 'ADCP: Ship Positions',
   proc_yearbase = 2024,
   fixfile = 'a_sp.gps',
   printformats = 'png',
   ddrange = None)

plt.show()
