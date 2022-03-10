#end of session: remove animals, write a note and run this script
note=["sal2 cage2 quad with previous start 18:48 lights 2132/0932, lick thresh 300, 120s wheel access 0.1s water is 10ul 1 pellet participants 38723977393 ,38723977500, 38723977309"]
injection_time=["11:17"]
issue=[""]#note here if something went wrong!

animal_list = ["2006010137","141821018163","141821018138","141821018308"]

import serial
import time
import RPi.GPIO as GPIO
import os
import pandas as pd
import statistics as stats
import time
import sys
from datetime import datetime
import numpy as np
os.chdir("/home/pi/Documents/Data/")

#mark end of session
class SaveData:
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
        event_list.update({'Date_Time': [datetime.now()]})
        event_list.update({'Wheel_Position': [wheel_position]})
        event_list.update({'FED_Position': [FED_position]})

        df_e = pd.DataFrame(event_list)
        #print(df_e)

        if not os.path.isfile(animaltag + "_events.csv"):
            df_e.to_csv(animaltag + "_events.csv", encoding="utf-8-sig", index=False)
        else:
            df_e.to_csv(animaltag + "_events.csv", mode="a+", header=False, encoding="utf-8-sig", index=False)

save = SaveData()
for x in range(np.size(animal_list)):
    animaltag=animal_list[x]
    save.append_event(issue, note, "end session", animaltag, injection_time, "")
    