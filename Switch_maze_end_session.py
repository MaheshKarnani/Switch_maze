#end of session: remove animals, write a note and run this script
note=["hab1 c4 LHdreadd lights 2230/1030, lick thresh 300, 120s wheel access 0.1s water is 10ul 1 pellet participants 38723977393 ,38723977500, 38723977309"]
injection_time=[""]
issue=[""]#note here if something went wrong!

animal_list = ["34443625017","34443624890","34443624728","141868466285"]
tickatlab_list=["04181-41015","04181-41016","04181-41017","04181-41018"]

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
import base64
from github import Github
from github import InputGitTreeElement
fd="/home/pi/Documents/Data/"
os.chdir(fd)

#deposit weight data to public repository
g = Github("token")
repo = g.get_user().get_repo('Switch_maze') # repo name
file_list=list()
file_names=list()
for i, entry in enumerate(animal_list):
    file_list.append(fd+animal_list[i]+"_weight.csv")
    file_names.append("wdata/"+tickatlab_list[i]+"_weight.csv")
commit_message = 'weights from 5s automatic measurement during entry'
master_ref = repo.get_git_ref('heads/main')
master_sha = master_ref.object.sha
base_tree = repo.get_git_tree(master_sha)
element_list = list()
for i, entry in enumerate(file_list):
    with open(entry) as input_file:
        data = input_file.read()
    element = InputGitTreeElement(file_names[i], '100644', 'blob', data)
    element_list.append(element)
tree = repo.create_git_tree(element_list, base_tree)
parent = repo.get_git_commit(master_sha)
commit = repo.create_git_commit(commit_message, tree, [parent])
master_ref.edit(commit.sha)

#mark end of session in event list
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
    