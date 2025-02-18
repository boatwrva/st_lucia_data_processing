
#!/usr/bin/env python

## written by quick_mplplots.py -- edit as needed:

## cruiseid      is 'ADCP'
## dbname        is 'a_sp'
## proc_yearbase is 2024
## printformats   is 'png'

import matplotlib.pyplot as plt





from pycurrents.adcp.quick_mpl import Btplot

## other parameters that can be chosen:
## These lines are formatted so you can just remove the '##' and they will
## just work; no additional formatting.

##   name                      default
##   ------                   --------------
##   dbname        = '../../adcpdb/aship' , # use the real name
##   titlestr      =   ' ADCP'     ,
##   load_only     =      False           , # if True; no graphical or text output
##   printformats  =      'pdf'           ,
##   dpi           =      100             ,
##   outfilebase   =     'btcal'          ,
##   ddrange       =      'all'           ,
##   step          =      1               ,
##   min_speed     =      2               ,
##   max_sig       =      2.5             ,
##   max_gap       =      0.1             ,
##   tol_dt        =      0.02            ,
##   min_depth     =      25              ,  #shallower for high freq
##   max_depth     =      1500            ,
##

BT = Btplot()
BT(btm_filename='a_sp.btm',
   ref_filename='a_sp.ref',
   cruiseid = 'ADCP',
   min_depth = 20,
   max_depth = 800,
   printformats = 'png',
   proc_yearbase='2024')

plt.show()
