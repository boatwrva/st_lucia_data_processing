

# shipkey = 'sp'
# shipname = 'R.G.Sproul'

# This file generated on
# date = '2020/02/24 21:57:40'

# for data acquisition (timers, paths, commands)
#================================================

# for DAS_while_cruise.py
#-------------------------
# List of paths to backup "data" subdirectories.  Within each such
# subdirectory, the cruise data directory (e.g., km0507) will
# be found.  If the active cruise is "km0507", then rsync will
# be called periodically to copy the contents of /home/data/km0507
# to data/km0507 in each path in the list.
backup_paths = [
]

spare_status_str = 'NOTE: This is the VIRTUAL computer, noy yet ready for primetime.'

# Interval in seconds between backups, usually 3600
rsync_t = 3600

# for DAS_while_logging.py
#--------------------------

# Figures updated based on ensemble length:
#    - lastens (amp, uv, pg) profile plot
#    - bridge plot (kts + direction)
#    - vector profile plot (bridge plot also in depth)
#    - last_few_vec plot (new)


# Interval in seconds between database updates:
# Set short_t to be about 2x enslength; depends on
#        computer speed (300sec for speedy computer, 600sec
#        for slower computers.
#        - Codas Database is updated at this frequency (run_quick.py)
#        - 3-day plots are made (includes panelN plot) (run_3day_plots.py)

short_t = 300

# Interval in seconds between diagnostics updates:
# Set long_t to be about 3x short_t (depends on computer speed)
#       These are ongoing diagnostic figures not science.
#       use 900sec (15min) on speedy computers,  otherwise 1800sec

long_t = 900

# Working directory for calculations and intermediate products:
workdir = '/home/adcp/uhdas_tmp'



# Extract compressed-form netcdf file for daily email.
# duration in days.  Disable by setting to 0
nc_ddstep = 1.2




# Command string to start up the speedlog
# Empty string '' or  None to disable the speedlog.
# NOTE: only supported with NB150
speedlog_cmd = '/usr/local/currents/bin/DAS_speedlog.py'


# for web plots and quality monitoring
#=====================================

## daily.py will generate statistics on these devices
## and quality plots will go on the web site on the short_t timer
## ==> This is now derived by uhdas.uhdas.proc_setup (from values
##     in hdg_inst_msgs, in proc_cfg.py) but it can be overridden
##     here as a list of heading instruments, eg ['posmv', 'adu5']

##ocean surveyor beam statistics;
# disable is emtpy, i.e.  [], else list plot types
beamstats = [
    'scattering',
    'velocity',
]

## shallowest bin to plot
top_plotbin = dict(
   os150bb = 1,
   os150nb = 1,
)

## which sonar will be used for kts+dir 5-minute bridge plots?
#prioritized list of strings (sonar)
kts_dir_instrument = [
    'os150bb',
    'os150nb',
]

#####################################

# for daily.py:
#--------------

# Each email "mailto" must be a list of email addresses:
#        ["et@this_ship.podunk.edu", "guru@podunk.edu"]
# An empty list (no addresses) is : []

email_comment_str = ''

tarball_mailto = [
    'uhdas@soest.hawaii.edu',
]

local_status_mailto = [
    'sts-cr-reports@ucsd.edu',
]

shore_status_mailto = [
    'sts-cr@ucsd.edu',
]

shore_status_bcc = [
    'uhdas@soest.hawaii.edu',
    'dropbox@rvdata.us',
]

##################

SMTP_server = 'smtp.rv-sproul.ucsd.edu'
mail_from = 'adcp@rv-sproul.ucsd.edu'
use_SSL = False

