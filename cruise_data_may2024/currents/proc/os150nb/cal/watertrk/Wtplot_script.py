
#!/usr/bin/env python

## written by quick_mplplots.py -- edit as needed:

## cruiseid      is 'ADCP'
## dbname        is 'a_sp'
## proc_yearbase is 2024
## printformats   is 'png'

import matplotlib.pyplot as plt





from pycurrents.adcp.quick_mpl import Wtplot

## other options that can be chosen
## These lines are formatted so you can just remove the '##' and they will
## just work; no additional formatting.

##
##       name                    value
##      -------------          -----------
##        cruiseid          =   'ADCP',
##        printformats      =   'pdf'        ,
##        dpi               =    100         ,
##        outfilebase       =   'wtcal'      ,
##        statsfile         =   'adcpcal.out',
##        load_only         =   False        ,    #if True: no plots, no output
##        comment           =   '#'          ,
##        ddrange           =   'all'        ,
##        clip_ph           =    3,          ,
##        clip_amp          =    0.04        ,
##        clip_var          =    0.05        ,
##        clip_dt           =    60          ,
##        clip_u            =    [-100,100]  ,
##        clip_v            =    [-100,100]  ,



WT = Wtplot()
WT(cal_filename = 'a_sp_7.cal',
  printformats = 'png',
  cruiseid = 'ADCP',
  proc_yearbase = '2024')

plt.show()
