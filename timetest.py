#timetest

import time
import sys, select, os
import pandas as pd
import statistics as stats
import sys
import datetime
import numpy as np

animal_list = ["2006010137","141821018163","141821018138","141821018308"]#mouse tags
entry_list=[0,0,0,0]

#recording parameters
start_time = datetime.datetime.now()+datetime.timedelta(minutes=1)
print(start_time)
stop_time = datetime.datetime(2022,2,25,9,30)
print(stop_time)
if start_time>stop_time:
    print("worked")
else:
    print("didn't")

animaltag="2006010137"
entry_list[animal_list.index(animaltag)]=1
animaltag="2006010137"
entry_list[animal_list.index(animaltag)]=1
animaltag="141821018308"
entry_list[animal_list.index(animaltag)]=1


res=input("press 1 and enter for 10min timer OR 0 and enter for immediate start")
res = int(res)
if res==1:
    while datetime.datetime.now()<start_time:
        nothing=1
elif res==0:
    nothing=0
print("worked2")
print(sum(entry_list))