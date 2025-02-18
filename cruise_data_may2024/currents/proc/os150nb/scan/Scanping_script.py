
#!/usr/bin/env python

## written by quick_adcp.py-- edit as needed:





from pycurrents.adcp.quick_npy import Scanping

Sc = Scanping()
Sc(dbname= 'a_sp',
   cfgpath = '/home/data/SP2403/proc/os150nb/config',
   configtype = 'python',
   cruisename = 'SP2403',
   py_gbindirbase = '/home/data/SP2403/gbin',
   sonar = 'os150nb',
   )


