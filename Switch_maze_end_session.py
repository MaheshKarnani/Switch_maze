#end of session: remove animals, write a note and run this script
note=["refeed C21 0.05mg/kg c6 LHdreadd lights 2230/1030, lick thresh 100, 120s wheel access 0.1s water is 10ul 1 pellet"]
injection_time=["10:30"]
issue=[""]#note here if something went wrong!

animal_list = ["34443624695","34443624808","137575399507","34443624982"]#mouse tags 
earmarks = ["R","L","RL","nm"]
tickatlab_list=["04435/1o1-42717","04435/1o1-42718","04435/1o1-42719","04435/1o1-42720"]

import serial
import time
import RPi.GPIO as GPIO
import os
import pandas as pd
import statistics as stats
import time
import sys
import datetime
import numpy as np
import base64
from github import Github
from github import InputGitTreeElement
fd="/home/pi/Documents/Data/"
os.chdir(fd)

#deposit weight data to public repository
g = Github("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")
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
    def append_event(self,rotation,food_time,event_type,animaltag,FED_position,hardware_time): #add hardware time call outs to below!
        
        """
        Function used to save event parameters to a .csv file
        """
        global event_list
        event_list = {
            "Date_Time": [],
            "Rotation": [],
            "Pellet_Retrieval": [],
            "Type" : [],
            "FED_Position": [],
            "hardware_time": []  
        }
        event_list.update({'Rotation': [rotation]})
        event_list.update({'Pellet_Retrieval': [food_time]})
        event_list.update({'Type': [event_type]})
        event_list.update({'Date_Time': [datetime.datetime.now()]})
        event_list.update({'FED_Position': [FED_position]})
        event_list.update({'hardware_time': [hardware_time]})
        df_e = pd.DataFrame(event_list)
        if not os.path.isfile(animaltag + "_events.csv"):
            df_e.to_csv(animaltag + "_events.csv", encoding="utf-8-sig", index=False)
        else:
            df_e.to_csv(animaltag + "_events.csv", mode="a+", header=False, encoding="utf-8-sig", index=False)
save = SaveData()
for x in range(np.size(animal_list)):
    animaltag=animal_list[x]
    save.append_event(issue, note, "end session", animaltag, injection_time, "")