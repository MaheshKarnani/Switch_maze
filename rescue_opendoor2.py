#open door2
import RPi.GPIO as GPIO
import os
import pandas as pd
import sys
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)
# set pin inputs from arduino
ard_pi_1 = 33 # reports BB1low
GPIO.setup(ard_pi_1,GPIO.IN)
# set pin outputs to arduino
pi_ard_1 = 15 # door1
pi_ard_2 = 13 # door2
pi_ard_3 = 16 # door3
give_pellet = 23 #trigger FED3
GPIO.setup(give_pellet, GPIO.OUT)
GPIO.output(give_pellet,False)# stop giving pellets
GPIO.setup(pi_ard_1,GPIO.OUT)
GPIO.setup(pi_ard_2,GPIO.OUT)
GPIO.setup(pi_ard_3,GPIO.OUT)
GPIO.output(pi_ard_1,False) # close door1
GPIO.output(pi_ard_2,True)# oepn door2
while True:
    if GPIO.input(ard_pi_1):
        GPIO.output(pi_ard_1,True) # open door1
        GPIO.output(pi_ard_2,False)# close door2
        print("returned")
        break

