
#import serial
import time
#import RPi.GPIO as GPIO
import os
import pandas as pd
import statistics as stats
import sys
from datetime import datetime
import numpy as np

#recording parameters
animal_list = ["38723977393","38723977500", "38723977309"] #list of tags in the recording (use scan tags code first to find out who they are)
water_time = 0.1 # seconds water dispensed when animal licks spout 0.1=20ul standard
run_time = 120 # running wheel availability in seconds 120s standard
chuck_lines=2 # chuck first weight reads for stability
nest_timeout=100 # timeout in nest after exiting maze in seconds 100s standard
heavy=40 # heavy (more than one mouse) limit in g, 40g standard
exit_wait=5#safety timer in seconds so outgoing is not trapped on exit, decrease when they learn to use
#which side run wheel and drink spout
def wheel_side(wheel):
    if wheel == "Left":
        FED = "Right"
    elif wheel == "Right":
        FED = "Left"
    return [wheel, FED]
wheel_position, FED_position = wheel_side("Left") #change here is goals switched from standard wheel_side("Left")
if wheel_position == "Right":
    ard_pi_3 = 36 #arduino pins BB3/4
    ard_pi_4 = 37 
elif wheel_position == "Left":
    ard_pi_3 = 37 #arduino pins BB3/4
    ard_pi_4 = 36 

#animal timers
animal_timer = animal_list.copy()
for x in range(np.size(animal_list)):
    animal_timer[x]=int(round(time.time()))-100

print(animal_timer)
print(animal_list)
print(animal_list.index(animaltag))
print(animal_timer[animal_list.index(animaltag)])

#mode timers
mode1timer=int(round(time.time())) #why?
mode3timer=int(round(time.time())) #why?
