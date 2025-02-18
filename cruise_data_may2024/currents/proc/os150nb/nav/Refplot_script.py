
#!/usr/bin/env python

## written by quick_mplplots.py -- edit as needed:

## cruiseid      is 'ADCP'
## dbname        is 'a_sp'
## proc_yearbase is 2024
## printformats   is 'png'

import matplotlib.pyplot as plt




from pycurrents.adcp.quick_mpl import Refplot

## other parameters that can be chosen
## name         default
## ----         -------
## outfilebase  'reflayer',
## printformats 'pdf',
## dpi           100,
## days_per_page 2.0,
## ddrange       [min, max]
## max_gap_ratio 0.05,
## min_speed     1.0,
## max_speed     5.0,
## ylim          [-1., 1.]


PT = Refplot()
PT(sm_filename='a_sp.sm',
   ref_filename='a_sp.ref',
    cruiseid = 'ADCP',
    proc_yearbase = 2024,
    printformats = 'png',
    ddrange = 'all')

plt.show()
