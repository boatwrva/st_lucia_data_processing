# This configuration file is Python code.  You should not
# need to change it; but if you do, you need to know that
# in Python, the *indentation matters*.

# The following will normally be empty lists, like this:
#
#ignore_ADCPs = []
#ignore_other_sensors = []
#
# But if you want to run with only a subset of the ADCPs
# and/or ancillary sensors that are defined in this file,
# you can list the ones you want to ignore like this:
#
#ignore_ADCPs = ['wh300', 'os75']
#ignore_other_sensors = ['GPS']
#
# In this case, you are listing the 'instrument' field of each
# ADCP or sensor you wish to exclude.
#

ignore_ADCPs = []
ignore_other_sensors = []
use_publishers = False


# 2-letter abbreviation for logging file prefix and constructing dbase name;
# read by procsetup.py
shipabbrev = "sp"


ADCPs = [
       { 'instrument'  :  'os150',
          'setup'       :  'rdi_setup',
          'terminal'    :  'oswh_term',
          'defaultcmd'  :  'os150_default.cmd',
          'commands'    : ('EA04500',),                   #xxx
          'datatypes'   :  ('os150nb', 'os150bb'),
          'wakeup_baud' :  19200,
        },

        ]


# Do not edit the next three lines:
common_opts = '-f %s -F -m 1 -H 2 ' % (shipabbrev,)
oswh_opts = '-lE -c -O -I'       # -O for OS/WH data format
                                  # -c for checksum, -I to initiate pinging

sensors = [

        { 'instrument'  :  'os150',       # Passive logging of OS150
          'device'      :  'ttySI0',     # used to have the wh300
          'baud'        :   19200,
          'format'      :  'binary',
          'subdir'      :  'os150',
          'ext'         :  'raw',
          'opt'         :  oswh_opts,       # port for speedlog index
        }, 



# ABXTWO replacement
        { 'instrument'  :  'BX992-UDP',   ## UDP has all messages in one line
          'device'      :  ':28063',# multicast at 10Hz
          'baud'        :   9600,
          'format'      :  'udp_ascii',
          'subdir'      :  'bx992',
          'ext'         :  'gph',
          'strings'     :  ('$GNGGA', '$GNHDT' ),
          'messages'    :  ('gps', 'gph'),
          'opt'         :  '-Y2 -c',
         },


        # replace synchro-converted feed with "GPS Compass" 2012/04/16
        { 'instrument'  :  'Furuno SC-30 ', #gps compass -- why no GGA messages?
          'device'      :  'ttySI2',
          'baud'        :   4800,
          'format'      :  'ascii',
          'subdir'      :  'gpshead',
          'ext'         :  'hdg',
          'strings'     :  ('$GPHDT','$GPRMC'),
          'messages'    :  ('gph',),
#          'opt'         :  '-Y2 -c -s10'}, #coming in at 10Hz
          'opt'         :  '-Y2 -c'},


        # 2020-01-26 dyang:
	# Cannot locate GP-170 serial feed; found GP-150 feed 
	{ 'instrument'  :  'GP170-A',   # was GP150
          'device'      :  'ttySI4',     # 'ttySI5', feeds were swapped
          'baud'        :   4800,
          'format'      :  'ascii',
          'subdir'      :  'gp170a',   #
          'ext'         :  'gps',
          'strings'     :  ('$GPGGA',),  
          'messages'    :  ('gps',),
          'opt'         :  '-Y2 -c'},



	{ 'instrument'  :  'GP170-B',
          'device'      :  'ttySI5',   #  'ttySI4', feeds were swapped
          'baud'        :   4800,
          'format'      :  'ascii',
          'subdir'      :  'gp170b',   #
          'ext'         :  'gps',
          'strings'     :  ('$GPGGA',),  
          'messages'    :  ('gps',),
          'opt'         :  '-Y2 -c'},




          ]


## enabling or disabling this occurs in procsetup_onship.py
speedlog_config = {
    'instrument'        : 'os150',
    'serial_device'     : '',  # fill with '/dev/ttyUSBx' or ''
#    'udp'               : "10.110.148.255:8888",  # optional; for KM
    'baud'              : 9600,
    'zmq_from_bin'      : "tcp://127.0.0.1:38010",
    'pub_addr'          : 'tcp://127.0.0.1:38020', #NO SPACES
    'eth_port'          : 'ens160',  # was eth0
#    'heading_offset'    : xx.x,    # get from EA_estimator.py
    'scale'             : 1.0,     # multiplies velocity measurement
    'bins'              : (1,3),   # zero-based; input to python slice()
    'navg'              : 5,       # pings to average
    }



## this section describes...
publishers = [
               {
               'subdir'      :  'bx992',
               'pub_addr'  :  'tcp://127.0.0.1:6789', # uses this port
               'sample_opts' :  '-tc -s60',
               },
             ]

#### DO NOT CHANGE the following ################

ADCPs = [A for A in ADCPs if A['instrument'] not in ignore_ADCPs]
sensors = [S for S in sensors if S['instrument'] not in ignore_ADCPs]
sensors = [S for S in sensors if S['instrument'] not in ignore_other_sensors]


if use_publishers==True:
    from uhdas.uhdas import make_publishers
    make_publishers.modify_sensors_and_publishers(sensors, publishers)

