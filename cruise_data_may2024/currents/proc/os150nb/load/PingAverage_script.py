
#!/usr/bin/env python

## written by quick_adcp.py-- edit as needed:





from pycurrents.adcp.quick_npy import PingAverage


# paths are relative to "load" (quick_adcp.py already 'cd load')
# hcorr inst must be set in control files

P = PingAverage()
P(sonar = 'os150nb',
  cruisename = 'SP2403',
  cfgpath = '/home/data/SP2403/proc/os150nb/config',
  configtype = 'python',
  py_gbindirbase = '/home/data/SP2403/gbin',
  edit_paramfile = 'ping_editparams.txt',
  xducer_dx = 0,
  xducer_dy = 0,
  uvwref_start = None,
  uvwref_end = None,
  ping_headcorr = True,
  ens_len = 180,
  max_BLKprofiles = 300,
  dday_bailout = None,
  new_block_on_start = False,
  use_rbins = False,
  incremental = True,   # required for pingpref
  pingpref = 'None',     #'bb' or 'nb'; see docs for details
  badbeam = None,  # 1,2,3,4
  beam_order = None, # [1,2,3,4] # a list
  yearbase = 2024)



