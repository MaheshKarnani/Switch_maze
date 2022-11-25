from RFIDreader_newcohort_functions import *

# wait for handler to leave room and begin experiment by pressing enter
input("Press Enter to start")

while True:
    # start
    if MODE == 1:
        print("\n MODE 1 open start \n")
        GPIO.output(pi_ard_1, True)  # open door1
        MODE = 2
    # animal on scale
    if MODE == 2 and GPIO.input(ard_pi_1):  # and GPIO.input(ard_pi_5) #top detector off
        #         print("\nMODE 2\n")
        w = read_scale()
        if w > 10 and w < heavy and GPIO.input(ard_pi_5):
            GPIO.output(pi_ard_1, False)  # close door1
            #             print("\nMODE 2 confirming sem occupancy\n")
            time.sleep(1)
            w = read_scale()
            if w > 10 and w < heavy:  # one animal
                print(datetime.now())
                MODE = 3
            else:
                MODE = 1
    # animal on scale
    if MODE == 3:
        #         print("\nMODE 3\n")
        secs = int(round(time.time()))
        # check RFID
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
    # animal going back home
    if MODE == 5 and GPIO.input(ard_pi_1):
        print("\nblock end\n")
        print(datetime.now())
        GPIO.output(pi_ard_2, False)  # close door 2
        GPIO.output(pi_ard_1, True)  # open door1
        #         animal_timer[animal_list.index(animaltag)]=int(round(time.time()))
        time.sleep(exit_wait)  # safety timer so outgoing is not trapped on exit
        MODE = 1
