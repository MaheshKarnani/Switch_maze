#ReadRFID tags to start a new cohort on Switch_maze
#2022#Feb14

import serial
import time
import RPi.GPIO as GPIO
import os

import pandas as pd
import statistics as stats
import sys
from datetime import datetime
import numpy as np

#recording parameters
animal_list = [] #list of tags in the recording (use scan tags code first to find out who they are)
chuck_lines=2 # chuck first weight reads for stability
heavy=40 # heavy (more than one mouse) limit in g, 40g standard
exit_wait=5#safety timer in seconds so outgoing is not trapped on exit, decrease when they learn to use

# set GPIO numbering mode
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False) # Ignore warning for now

#initialize serial port for usb RFID
serRFID = serial.Serial()
serRFID.port = '/dev/ttyUSB1' 
serRFID.baudrate = 9600
serRFID.timeout = 100 #specify timeout when using readline()
serRFID.open()
if serRFID.is_open==True:
    print("\nRFID antenna ok. Configuration:\n")
    print(serRFID, "\n") #print serial parameters
serRFID.close()

#initialize serial port for usb OpenScale
ser = serial.Serial()
ser.port = '/dev/ttyUSB0' 
ser.baudrate = 19200
ser.timeout = 100000
#specify timeout when using readline()
ser.open()
ser.flush()
for x in range(10):
    line=ser.readline()
    print(line)
if ser.is_open==True:
    print("\nScale ok. Configuration:\n")
    print(ser, "\n") #print serial parameters

# set pin inputs from arduino
ard_pi_1 = 33 # reports BB1low
ard_pi_2 = 35 # reports BB2low
ard_pi_5 = 38 # reports BB5high
ard_pi_lick = 32 # reports Capacitive lick sensor

# set pins to and from FED3
Food_retrieval = 11 # BNC output FED3
GPIO.setup(Food_retrieval, GPIO.IN)
give_pellet = 10 #trigger FED3
GPIO.setup(give_pellet, GPIO.OUT)

# pin to water valve
give_water = 29 #to valve
GPIO.setup(give_water, GPIO.OUT)

#set pin inputs from running wheel rotary encoder
clk=12
GPIO.setup(clk,GPIO.IN)
clkLastState=GPIO.input(clk)

#set pin input room door sensor
room_door=22 #IR proximity detector on room door
GPIO.setup(room_door,GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

# set pin outputs to arduino
pi_ard_1 = 15 #open door1
pi_ard_2 = 13 #open door2
pi_ard_3 = 16 #open door3
pi_ard_4ow = 5 #open wheel
Pi_capture_1  =40 #start miniscope
PiArd_reset = 18 #reset arduino

GPIO.setup(pi_ard_1,GPIO.OUT)
GPIO.setup(pi_ard_2,GPIO.OUT)
GPIO.setup(pi_ard_3,GPIO.OUT)
GPIO.setup(pi_ard_4ow,GPIO.OUT)
GPIO.setup(Pi_capture_1,GPIO.OUT)
GPIO.setup(PiArd_reset,GPIO.OUT)
GPIO.output(pi_ard_1,False)
GPIO.output(pi_ard_2,False)
GPIO.output(pi_ard_3,False)
GPIO.output(pi_ard_4ow,False)
GPIO.output(Pi_capture_1,False)
GPIO.output(PiArd_reset,False)#why?
time.sleep(0.1)
GPIO.output(PiArd_reset,True)#why?

#initialize state variables
MODE=1
choice_flag=False
counter=0
cycle=90 #cycle on running wheel gives this many counts 90 for copal; 1200 for 600B
run_flag=False
food_flag=False
water_flag=True
flag_heavy=False
flag_animals_left = False
task_complete_flag = False
entry_flag = False
another_entered=False
sub_flag=False
substition=0
food_clk_end = 0
food_clk_start = 0
run_clk_start = 0

#mode timers
mode1timer=int(round(time.time())) #why?
mode3timer=int(round(time.time())) #why?

'''
begin loop function defs
'''    
def RFID_readtag(RFIDnum):
    """
    This function reads the RFID tag, removes the junk incoming and returns the
    converted ID from hexadecimal to decimal.
    """
    RFIDtimer=int(round(time.time()))
    if RFIDnum == "RFID1":
        try:
            serRFID.close()
            serRFID.open()
            serRFID.flush()
            junk     = serRFID.read(1)
            tag      = serRFID.read(10)
            checksum = serRFID.read(2)
            junk2    = serRFID.read(3)          
            animaltag = str(int(tag, 16)) # transform from hexadecimal to a number
            print(animaltag)
            serRFID.close()
            return animaltag
        except:
            serRFID.close()
            print("Something went wrong")
            animaltag = False
            return animaltag

def acquire_weight(animaltag):
    global chuck_lines
    """
    This function is used to acquire 50 datapoints of the animals weight and returns
    a few different parameters - mean, median, mode, max_mode(the latter does not
    work in python 3.7). Mode tends to be the most accurate metric.
    """
    print("Acquiring weight")
    flag_heavy = False
    ys = [] #store weights here
    ser.close()
    ser.open()
    ser.flush()
    for x in range(chuck_lines): # chuck lines 
        line=ser.readline()
    for x in range(50): # 50 lines*120ms per line=6s of data 
        line=ser.readline()
        if x % 1 == 0:
            print(line)
        line_as_list = line.split(b',')
        relProb = line_as_list[0]
        relProb_as_list = relProb.split(b'\n')
        relProb_float = float(relProb_as_list[0])
        relProb_float = relProb_float*1000
        # More than one animal:
        if relProb_float > heavy:
            print("MULTIPLE ANIMALS ON SCALE")
            flag_heavy = True
            return flag_heavy
        else:
            ys.append(relProb_float)
    
    if not flag_heavy:
        for i in range(len(ys)):
            ys[i] = round(ys[i],3)
        weight_data_mean = stats.mean(ys)
        weight_data_median = stats.median(ys)
        # mode
        try:
            weight_data_mode = stats.mode(ys)
        except:
            weight_data_mode = "NO MODE"
        # mode max
        try:
            weight_data_max_mode = stats.multimode(ys)
            weight_data_max_mode = weight_data_max_mode[-1] # largest of modes
        except:
            weight_data_max_mode = "NO MAX_MODE"
        #appending data to database
        save = SaveData()
        save.append_weight(weight_data_mean, weight_data_median,
        weight_data_mode, weight_data_max_mode,animaltag)
        return flag_heavy
  
def read_scale():
    """
    This function takes a quick read to sense the scale.
    """
    global chuck_lines
    m = [] #store weights here
    ser.close()
    ser.open()
    ser.flush()
    for x in range(chuck_lines): # chuck lines 
        line=ser.readline()
    for x in range(3): # 3 lines*120ms per line=0.4s of data 
        line=ser.readline()
        if x % 1 == 0:
            print(line)
        line_as_list = line.split(b',')
        relProb = line_as_list[0]
        relProb_as_list = relProb.split(b'\n')
        n = float(relProb_as_list[0])
        n = n*1000
        m.append(n)
    w=stats.mean(m)
    return w    

GPIO.setup(ard_pi_1,GPIO.IN)
GPIO.setup(ard_pi_2,GPIO.IN)
GPIO.setup(ard_pi_5,GPIO.IN)


#wait for handler to leave room and begin experiment by pressing enter
input("Press Enter to start")
'''
begin execution loop
'''
while True:
    #start
    if MODE == 1:
        print("\n MODE 1 open start \n")
        GPIO.output(pi_ard_1,True) # open door1
        MODE = 2
    #animal on scale    
    if MODE == 2 and GPIO.input(ard_pi_1): # and GPIO.input(ard_pi_5) #top detector off
#         print("\nMODE 2\n")
        w=read_scale()
        if w>10 and w<heavy and GPIO.input(ard_pi_5):
            GPIO.output(pi_ard_1,False) # close door1
#             print("\nMODE 2 confirming sem occupancy\n")
            time.sleep(1)
            w=read_scale()
            if w>10 and w<heavy: #one animal
                print(datetime.now())
                MODE = 3
            else:
                MODE = 1   
    #animal on scale
    if MODE == 3:
#         print("\nMODE 3\n")
        secs=int(round(time.time()))
        #check RFID
        print("Reading animal tag")
        while True:
            animaltag = RFID_readtag("RFID1")
            if not animaltag in animal_list:
                MODE = 5
                print("animal not in list")
                print(animaltag)
                break   
            else:
                MODE = 5
                break                       
#animal going back home    
    if MODE == 5 and GPIO.input(ard_pi_1):
        print("\nblock end\n")
        print(datetime.now())
        GPIO.output(pi_ard_2,False) # close door 2
        GPIO.output(pi_ard_1,True) # open door1
#         animal_timer[animal_list.index(animaltag)]=int(round(time.time()))
        time.sleep(exit_wait)#safety timer so outgoing is not trapped on exit
        MODE = 1
