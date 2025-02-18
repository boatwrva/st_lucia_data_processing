shipname = 'R.G.Sproul'
cruiseid = 'SP2403'
yearbase = 2024
uhdas_dir = '/home/data/SP2403'

# from proc_cfg.*:



## for processing
##----------------
## ship name: shipname = 'R.G.Sproul'
## at-sea "proc_cfg.py" initialized date = '2020/02/24 21:57:40'
##
## This file starts as /home/adcp/config/proc_cfg.py and
## includes the following information.  Uncomment, left-justify
## and fill these in if you are attempting to generate proc_cfg.py
## from this template.  The file must be named {cruiseid}_proc.py
## or for this example, kk1105_proc.py
##
## example values: fill in for your cruise...
#
# yearbase = 2011                  # usually year of first data logged
# uhdas_dir = '/home/data/kk1105'  # path to uhdas data directory
# shipname = 'Ka`imikai O Kanaloa' # for documentation
# cruiseid = 'kk1105'              # for titles
#
#

#======== serial inputs =========

# choose position instrument (directory and rbin message)

pos_inst = 'gp170b'
pos_msg = 'gps'

# choose attitude  instruments (directory and rbin message)

pitch_inst = ''     # pitch is recorded, but NOT used in transformation
pitch_msg = ''      # disable with '' (not None)

roll_inst = ''      # roll is recorded, but NOT used in transformation
roll_msg = ''       # disable with '' (not None)

hdg_inst = 'gpshead'  # reliable heading, used for beam-earth transformation
hdg_msg = 'gph'


## heading correction
## all heading+msg pairs, for hbin files
hdg_inst_msgs = [
    ('gpshead', 'gph'),
    ('bx992', 'gph'),
]
#

## instrument for heading corr to ADCP data (dir and msg)
hcorr_inst = 'bx992'       # disable with '' (not None)
hcorr_msg = 'gph'        # disable with '' (not None)
hcorr_gap_fill = 1.5   ## fallback correction for hcorr gaps
                     ## calculate hdg_inst - hcorr_inst, eg gyro - abxtwo_b2udp
                     ## SAME SIGN CONVENTION as cal/rotate/ens_hcorr.ang


## if there is a posmv
acc_heading_cutoff = 0.02

# =========== ADCP transformations========
# historically, values were substituted into cruise_proc.m 
# now, in Python, they are used directly

# heading alignment:  nominal - (cal/watertrack)
h_align = dict(
#      os150 =  40.88,  # 43.88 - (3.0),   # SP2216 - JH stupid
#      os150 =  46.88,  # 43.88 - (-3.0),   # SP2217
    os150 = 46.85, # 46.4 - (-0.45) = 46.85 # SP2304
)

# transducer depth, meters
ducer_depth = dict(
     os150 = 3,
)

# velocity scalefactor
# see SoundspeedFixer in pycurrents/adcp/pingavg.py
scalefactor = dict(
   os150bb = 1.0,
   os150nb = 1.0,
)

# soundspeed
soundspeed = dict(
   os150bb = None,
   os150nb = None,
)

# salinity
salinity = dict(
   os150bb = None,
   os150nb = None,
)

#=================================================================
# =========           values for quick_adcp.py          ==========
# ========= These are set here for at-sea procesing,    ==========
# ========= but are REQUIRED in quick_adcp.py control   ==========
# =========  file for batch mode or reprocessing.       ==========

## choose whether or not to use topography for editing
## 0 = "always use amplitude to guess the bottom;
##          flag data below the bottom as bad
## -1 = "never search for the bottom"
## positive integer: Only look for the bottom in deep water
##      "deep water" defined as "topo database says greater than this"

max_search_depth = dict(
   os150bb = 1000,
   os150nb = 1000,
)

# special: weakprof_numbins
weakprof_numbins = dict(
   os150bb = None,
   os150nb = None,
)

# set averaging intervals
enslength = dict(
    os150bb = 180,
    os150nb = 180,
)

# Estimate of offset between ADCP transducer and gps
# this has one value per instrument
# ADCP (dx=startboard, dy=fwd) meters from GPS
# specify integer values for 'xducer_dx' and 'xducer_dy' for each instrument,
#      as from cal/watertrk/guess_xducerxy

xducer_dx = dict(
)
xducer_dy = dict(
)

## if there is a bad beam, create a dictionary modeled after
## enslen (i.e. Sonar-based, not instrument based) and use the
## RDI number (1,2,3,4) to designate the beam to leave out.


