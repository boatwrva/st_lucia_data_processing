
#!/usr/bin/env python

## written by quick_adcp.py-- edit as needed:




from pycurrents.adcp.quick_npy import Refsm

# refuv_inputfile  : identify the filename for determining uship, vship
#                  :     - defaults to position file (t,x,y)
#                  :     - but could be uvship from Pingavg
# refuv_source : identify what the columns mean:
#              :   - 'nav' (for positions) columns 0, 1, 2
#              :   - 'uvship' (for uvship) columns 0, 1, 2
# ens_len      : averaging length in seconds
# bl_half_width: blackman filter halfwidth (number of ensembles)
#              : default = 3
#              : setting to 0 disables smoothing
#              :    still use refsm to write the 'refsm_tuv.asc' file
#              : This variable is called "refuv_smoothwin" in the options
#              :
#  For more details, see pycurrents.adcp.nav.RefSmooth

Ref = Refsm()
Ref(dbname='a_sp',
    dbpath='../adcpdb',
    proc_yearbase=2024,
    refuv_inputfile='a_sp.gps',
    refuv_source='nav',
    ens_len=180,
    bl_half_width=3,
    pgmin=50,
    rl_startbin=2,
    rl_endbin=20)


