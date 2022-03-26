#Switch_maze
#2022#Feb21

import serial
import time
import RPi.GPIO as GPIO
import os
import pandas as pd
import statistics as stats
import sys
import datetime
import numpy as np

#recording parameters
start_time = datetime.datetime.now()+datetime.timedelta(minutes=10)
stop_time = datetime.datetime(2022,3,27,9,30)#input stop time date, hour, minute
animal_list = ["2006010137","141821018163","141821018138","141821018308"]#mouse tags
entry_list=[0,0,0,0]
#animal_list = ["202100030","137575399426", "2006010085"]#test tags
soc_pause_length=30 #minutes to pause in between social order sessions
water_time = 0.1 # seconds water dispensed when animal licks spout 0.1=20ul standard
run_time = 120 # running wheel availability in seconds 120s standard
chuck_lines=2 # chuck first weight reads for stability
nest_timeout=100 # timeout in nest after exiting maze in seconds 100s standard
heavy=40 # heavy (more than one mouse) limit in g, 40g standard
exit_wait=1#safety timer in seconds so outgoing is not trapped on exit, decrease when they learn to use
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

# change directory to document data folder
os.chdir("/home/pi/Documents/Data/")     

# set GPIO numbering mode
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False) # Ignore warning for now

#initialize serial port for usb RFID
serRFID = serial.Serial()
serRFID.port = '/dev/ttyUSB2' 
serRFID.baudrate = 9600
serRFID.timeout = 100 # timeout in seconds when using readline()
serRFID.open()
if serRFID.is_open==True:
    print("\nRFID antenna ok. Configuration:\n")
    print(serRFID, "\n") #print serial parameters
serRFID.close()

#initialize serial port for usb OpenScale
ser = serial.Serial()
ser.port = '/dev/ttyUSB1' 
ser.baudrate = 19200
ser.timeout = 100
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
Food_retrieval = 10 # BNC output FED3, was 11 3V 
GPIO.setup(Food_retrieval, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
give_pellet = 23 #trigger FED3
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
pi_ard_calibrate_lick = 24 #recalibrate capacitive lick sensor

GPIO.setup(pi_ard_1,GPIO.OUT)
GPIO.setup(pi_ard_2,GPIO.OUT)
GPIO.setup(pi_ard_3,GPIO.OUT)
GPIO.setup(pi_ard_4ow,GPIO.OUT)
GPIO.setup(Pi_capture_1,GPIO.OUT)
GPIO.setup(PiArd_reset,GPIO.OUT)
GPIO.setup(pi_ard_calibrate_lick,GPIO.OUT)
GPIO.output(pi_ard_1,False)
GPIO.output(pi_ard_2,False)
GPIO.output(pi_ard_3,False)
GPIO.output(pi_ard_4ow,True) # open running wheel
GPIO.output(Pi_capture_1,False)
GPIO.output(pi_ard_calibrate_lick,False)
GPIO.output(PiArd_reset,False)#?
time.sleep(0.1)
GPIO.output(PiArd_reset,True)#?

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
soc_pause_flag=False
substition=0
food_clk_end = 0
food_clk_start = 0
run_clk_start = 0
#animal timers 
animal_timer = animal_list.copy()
for x in range(np.size(animal_list)):
    animal_timer[x]=int(round(time.time()))-nest_timeout

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
            #print("+", end=",")
            #print("Something went wrong")
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
    for x in range(2): # 2 lines*120ms per line=0.3s of data 
        line=ser.readline()
        line_as_list = line.split(b',')
        relProb = line_as_list[0]
        relProb_as_list = relProb.split(b'\n')
        n = float(relProb_as_list[0])
        n = n*1000
        m.append(n)
    w=stats.mean(m)
    return w    
        
class SaveData:
    def append_weight(self,weight_data_mean, weight_data_median,
                      weight_data_mode, weight_data_max_mode,
                      animaltag):
        """
        Function used to save weight parameters to a .csv file
        """
        weight_list = {
        "Weight_Mean": [],
        "Weight_Median": [],
        "Weight_Mode": [],
        "Weight_Max_Mode": [],
        "Date_Time": []
        }
        weight_list.update({'Weight_Mean': [weight_data_mean]})
        weight_list.update({'Weight_Median': [weight_data_median]})
        weight_list.update({'Weight_Mode': [weight_data_mode]})
        weight_list.update({'Weight_Max_Mode': [weight_data_max_mode]})
        weight_list.update({'Date_Time': [datetime.datetime.now()]})
        df_w = pd.DataFrame(weight_list)
        print(df_w)
        if not os.path.isfile(animaltag + "_weight.csv"):
            df_w.to_csv(animaltag + "_weight.csv", encoding="utf-8-sig", index=False)
            print("weight file created")
        else:
            df_w.to_csv(animaltag + "_weight.csv", mode="a+", header=False, encoding="utf-8-sig", index=False)
            print("weight file appended")
        
    def append_event(self,rotation,food_time,event_type,animaltag,
                     wheel_position,FED_position):
        """
        Function used to save event parameters to a .csv file
        """
        global event_list
        event_list = {
            "Date_Time": [],
            "Rotation": [],
            "Pellet_Retrieval": [],
            "Type" : [],
            "Wheel_Position": [],
            "FED_Position": []    
        }
        event_list.update({'Rotation': [rotation]})
        event_list.update({'Pellet_Retrieval': [food_time]})
        event_list.update({'Type': [event_type]})
        event_list.update({'Date_Time': [datetime.datetime.now()]})
        event_list.update({'Wheel_Position': [wheel_position]})
        event_list.update({'FED_Position': [FED_position]})
        df_e = pd.DataFrame(event_list)
        if not os.path.isfile(animaltag + "_events.csv"):
            df_e.to_csv(animaltag + "_events.csv", encoding="utf-8-sig", index=False)
        else:
            df_e.to_csv(animaltag + "_events.csv", mode="a+", header=False, encoding="utf-8-sig", index=False)

def door_callback(channel):
    if not GPIO.input(room_door):
        print("door closed")      
        for x in range(np.size(animal_list)):
            fn=animal_list[x]
            save.append_event(run_time, water_time, "room door closed", fn, wheel_position, FED_position)
    else:
        print("door OPEN")
        for x in range(np.size(animal_list)):
            fn=animal_list[x]
            save.append_event(run_time, water_time, "room door opened", fn, wheel_position, FED_position)

GPIO.add_event_detect(room_door, GPIO.BOTH, callback=door_callback, bouncetime=50) #interrupt with threaded callback
save = SaveData()
GPIO.setup(ard_pi_1,GPIO.IN)
GPIO.setup(ard_pi_2,GPIO.IN)
GPIO.setup(ard_pi_3,GPIO.IN)
GPIO.setup(ard_pi_4,GPIO.IN)
GPIO.setup(ard_pi_5,GPIO.IN)
GPIO.setup(ard_pi_lick,GPIO.IN,GPIO.PUD_DOWN)

#start when start_time is passed or immediately
res=input("press 1 and enter for Xmin timer OR 0 and enter for immediate start")
res = int(res)
if res==1:
    while datetime.datetime.now()<start_time:
        dummy=1
elif res==0:
    dummy=0

#save session parameters
for x in range(np.size(animal_list)):
    animaltag=animal_list[x]
    save.append_event(run_time, water_time, "begin session", animaltag, wheel_position, FED_position)

#social order session start marker
for x in range(np.size(animal_list)):
    animaltag=animal_list[x]
    save.append_event(run_time, water_time, "social order session", animaltag, wheel_position, FED_position)
'''
begin execution loop
'''
while True:
    #start
    if MODE == 1:
        print("\n MODE 1 open start \n")
        GPIO.output(pi_ard_1,True) # open door1
        MODE = 3
        print("\nMODE 3\n")
        print("Scanning RFID tag in scale")
        print(datetime.datetime.now())
    if MODE == 2:
        #stop mode
        w=read_scale()
        if w<10 and GPIO.input(ard_pi_5):
            GPIO.output(pi_ard_1,False) # close door1
            time.sleep(60)
            print("stopped")
        elif w<10:
            time.sleep(60) # scan every 1min for safety
        elif w>10:
            GPIO.output(pi_ard_1,True) # open door1
            time.sleep(10) #exit window
        if soc_pause_flag and datetime.datetime.now()>soc_timer+datetime.timedelta(minutes=soc_pause_length):
            soc_pause_flag=False
            MODE = 1
            #social order session start marker
            for x in range(np.size(animal_list)):
            animaltag=animal_list[x]
            save.append_event(run_time, water_time, "social order session", animaltag, wheel_position, FED_position)
    #animal on scale
    if MODE == 3:
        while True:
            animaltag = RFID_readtag("RFID1")
            if datetime.datetime.now()>stop_time:
                MODE = 2
                print(datetime.datetime.now())
                print("STOPPING MAZE because stop_time was reached")
                break
            if sum(entry_list)==4:
                entry_list=[0,0,0,0]
                MODE = 2
                print(datetime.datetime.now())
                print("Pausing MAZE because social order session is complete")
                soc_timer=datetime.datetime.now()
                soc_pause_flag=True
                #social order session stop marker
                for x in range(np.size(animal_list)):
                animaltag=animal_list[x]
                save.append_event(run_time, water_time, "social order session stop", animaltag, wheel_position, FED_position)
                break
            if animaltag:
                w=read_scale()
                if not animaltag in animal_list:
                    MODE = 3
                    print("animal not in list")
                    print(animaltag)
                    break   
                elif w>10 and w<heavy and GPIO.input(ard_pi_5) and int(round(time.time()))-animal_timer[animal_list.index(animaltag)]>nest_timeout:
                    GPIO.output(pi_ard_1,False) # close door1
                    MODE = 4
                    choice_flag=False
                    entry_flag=False
                    water_flag=True
                    break
            else:
                MODE = 3
                print("*", end=",")
                break
                
    #correct animal on scale
    if MODE == 4:
        print("\nMODE 4\n") 
        # Weighing for entry
        flag_heavy = acquire_weight(animaltag)
        if flag_heavy:
            #Append data
            save.append_event("+", "", "ENTRY DENIED MULTIPLE ANIMALS", animaltag, wheel_position, FED_position)
            MODE = 1
        if not flag_heavy:
            GPIO.output(pi_ard_2,True) # open door 2
            GPIO.output(pi_ard_3,True) # open door 3
            MODE = 5
            entry_list[animal_list.index(animaltag)]=1
            print("\nMODE 5\n")       
            print("\nblock start\n")
            print(animaltag)
            print(datetime.datetime.now())
            print("social order completion")
            print(sum(entry_list))
            mode5timer=int(round(time.time()))
            #Append data
            save.append_event("+", "", "START", animaltag, wheel_position, FED_position)
    #time out mode5 if animal did not enter maze
    if MODE == 5 and not entry_flag and int(round(time.time()))>mode5timer+300:
        GPIO.output(pi_ard_2,False) # close door 2
        MODE=1
    #animal at decision point
    if MODE == 5 and GPIO.input(ard_pi_2) and not choice_flag: 
        #BB2 triggered, write data
        print("\ntrial start\n")
        GPIO.output(pi_ard_3,True) # open door 3
        #  send pulse to FED
        GPIO.output(give_pellet,True) # prepare a pellet
        if water_flag:
            GPIO.output(give_water,True) # prepare a water drop
            time.sleep(0.001)
            GPIO.output(give_water,False) 
            water_flag=False
        # append BB2 for the first time the animal enters the maze
        if event_list["Type"] == ["START"]:
            save.append_event("*", "", "BB2", animaltag, wheel_position, FED_position)
        # append food data
        if food_flag:
#             print("appending food pod data")
            cycles_str = round(counter/cycle,4)
            save.append_event(cycles_str, "", "Food_log_BB2", animaltag, wheel_position, FED_position)
        # append run data
        if run_flag:
#             print("appending running wheel data, licks:")
            print(licks)
            cycles_str = round(counter/cycle,4)
            save.append_event(cycles_str, "", "Run_log_BB2", animaltag, wheel_position, FED_position)
            save.append_event(licks, drink_delay, "exit_drink", animaltag, wheel_position, FED_position)
        #start camera capture/opto
        GPIO.output(Pi_capture_1,True)
        choice_flag=True
        entry_flag=True
        run_flag=False
        food_flag=False
        lick_flag=True
        licks=0
        counter=0
        food_clk_end=0
        pellet_complete_flag=True

    #animal going back home    
    if MODE == 5 and GPIO.input(ard_pi_1) and choice_flag:
        print("\nblock end\n")
        print(datetime.datetime.now())
        GPIO.output(pi_ard_2,False) # close door 2
        GPIO.output(pi_ard_1,True) # open door1
        save.append_event("-", "", "END", animaltag, wheel_position, FED_position)
        GPIO.output(Pi_capture_1,False)
        GPIO.output(give_pellet,False)
        run_flag=False
        food_flag=False
        another_entered=False
        choice_flag=False
        entry_flag = False
        animal_timer[animal_list.index(animaltag)]=int(round(time.time()))
        time.sleep(exit_wait)#safety timer so outgoing is not trapped on exit
        GPIO.output(pi_ard_calibrate_lick,True)
        time.sleep(0.5)
        GPIO.output(pi_ard_calibrate_lick,False)
        time.sleep(0.1)
        MODE = 1
    #enter food pod    
    if MODE == 5 and GPIO.input(ard_pi_4) and choice_flag: 
        print("\nenter food\n")
        GPIO.output(give_pellet,False) # signal back low so you can trigger next one
        GPIO.output(pi_ard_3,False) # close door 3
        save.append_event("*", "", "BB4", animaltag, wheel_position, FED_position)
        food_clk_start = time.process_time()
        choice_flag=False
        food_flag=True
        limit=cycle         
    #enter running wheel pod
    if MODE == 5 and GPIO.input(ard_pi_3) and choice_flag: 
        print("\nenter water\n")
        GPIO.output(pi_ard_4ow,True) # open running wheel
        GPIO.output(pi_ard_3,False) # close door 3
        save.append_event("*", "", "BB3", animaltag, wheel_position, FED_position)
        run_clk_start = time.process_time()
        choice_flag=False
        run_flag=True
        limit=cycle
#         water_flag=False
        lick_timer=int(round(time.time() * 1000))
        licks=0
        drink_delay=0
    #record delay to food retrieval    
    if food_flag:
        if GPIO.input(Food_retrieval) and pellet_complete_flag:
            food_clk_end = round(time.process_time() - food_clk_start, 4)
            pellet_complete_flag=False
            print("EAT") 
            save.append_event("", food_clk_end, "Food_retrieval", animaltag, wheel_position, FED_position) 
    #record running wheel and licking   
    if run_flag:
        clkState=GPIO.input(clk)
        if clkState != clkLastState:
            counter += 1  
            clkLastState = clkState
        if counter >= limit:
            print(counter)    
            limit=counter+cycle
        if time.process_time()-run_clk_start>run_time:
            GPIO.output(pi_ard_4ow,False) # close running wheel
        if GPIO.input(ard_pi_lick):
            licks=licks+1 
            water_flag=True
            if lick_flag:
                drink_delay=int(round(time.time() * 1000))-lick_timer
                save.append_event("", drink_delay, "drink", animaltag, wheel_position, FED_position) 
                GPIO.output(give_water,True) # give a water drop
                time.sleep(water_time)
                GPIO.output(give_water,False) 
                lick_flag=False
                print("DRINK") 
print("loop end")
