
#!/usr/bin/env python

## written by quick_mplplots.py -- edit as needed:

## cruiseid      is 'ADCP'
## dbname        is 'a_sp'
## proc_yearbase is 2024
## printformats   is 'png'

import matplotlib.pyplot as plt






from pycurrents.adcp.quick_mpl import Hcorrplot

PH = Hcorrplot()
PH(hcorr_filename= 'ens_hcorr.asc',
   titlestr = 'ADCP: Heading Correction',
   outfilebase = 'ens_hcorr_mpl',
   printformats = 'png',
   proc_yearbase = 2024,
   ddrange = 'all')




plt.show()
